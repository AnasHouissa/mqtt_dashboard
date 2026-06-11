import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../data/db/database.dart';

enum MqttStatus { disconnected, connecting, connected, failed }

/// Why a connection attempt failed, so the UI can show a meaningful reason.
enum MqttFailureReason {
  /// Couldn't reach the broker at all (bad host/port, refused, timeout, no net).
  network,

  /// The broker rejected the supplied username/password.
  badCredentials,

  /// The broker is reachable but unavailable to serve the connection.
  brokerUnavailable,

  /// The broker rejected the connection request (bad client id / protocol).
  rejected,

  /// Anything we couldn't classify.
  unknown,
}

/// A parsed numeric message received on a subscribed topic.
class TopicMessage {
  final String topic;
  final double value;
  final DateTime timestamp;
  const TopicMessage(this.topic, this.value, this.timestamp);
}

/// A raw, unparsed message received on a subscribed topic. Emitted for every
/// incoming message regardless of whether the payload is numeric, so the UI
/// can show the live feed verbatim. [numeric] is the parsed value when the
/// payload was understood (and thus stored as a reading), or null otherwise.
class RawMessage {
  final String topic;
  final String payload;
  final double? numeric;
  final DateTime timestamp;
  const RawMessage(this.topic, this.payload, this.numeric, this.timestamp);
}

/// Wraps a single broker connection over TCP.
///
/// Subscribes to metric topics, parses numeric payloads and exposes them on
/// [messages]. Callers (a provider) persist them as readings.
class MqttService {
  MqttServerClient? _client;

  /// QoS / retain defaults captured from the broker on [connect], reused by
  /// [subscribe] and [publish] while the connection is live.
  MqttQos _qos = MqttQos.atLeastOnce;
  bool _retain = false;

  final _statusController = StreamController<MqttStatus>.broadcast();
  final _messageController = StreamController<TopicMessage>.broadcast();
  final _rawController = StreamController<RawMessage>.broadcast();

  MqttStatus _status = MqttStatus.disconnected;
  MqttStatus get status => _status;

  /// Set whenever a [connect] attempt ends in [MqttStatus.failed]; cleared on
  /// a successful connect. Lets the UI explain *why* the connection failed.
  MqttFailureReason? _lastFailureReason;
  MqttFailureReason? get lastFailureReason => _lastFailureReason;

  Stream<MqttStatus> get statusStream => _statusController.stream;
  Stream<TopicMessage> get messages => _messageController.stream;

  /// Every incoming message verbatim, numeric or not.
  Stream<RawMessage> get rawMessages => _rawController.stream;

  void _setStatus(MqttStatus s) {
    _status = s;
    if (!_statusController.isClosed) _statusController.add(s);
  }

  Future<bool> connect(Broker broker) async {
    await disconnect();

    final clientId =
        'mqtt_dash_${broker.id}_${broker.name.hashCode.toUnsigned(16)}';
    _qos = qosFromInt(broker.qos);
    _retain = broker.retain;

    final client = MqttServerClient.withPort(
      broker.address,
      clientId,
      broker.port,
    );
    client.logging(on: true);
    client.secure = broker.secure;
    client.keepAlivePeriod = broker.keepAlive;
    client.connectTimeoutPeriod = broker.connectTimeout * 1000;
    client.autoReconnect = true;
    client.onConnected = () => _setStatus(MqttStatus.connected);
    client.onDisconnected = () => _setStatus(MqttStatus.disconnected);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean();
    if (broker.username != null && broker.username!.isNotEmpty) {
      connMessage.authenticateAs(broker.username, broker.password ?? '');
    }
    client.connectionMessage = connMessage;

    _client = client;
    _setStatus(MqttStatus.connecting);

    try {
      await client.connect();
    } catch (_) {
      // The thrown exception rarely carries the broker's return code, so we
      // classify from the connection status (which is populated on refusal).
      _lastFailureReason = _classify(client.connectionStatus);
      _setStatus(MqttStatus.failed);
      client.disconnect();
      _client = null;
      return false;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      _lastFailureReason = null;
      _setStatus(MqttStatus.connected);
      _listen();
      return true;
    }
    _lastFailureReason = _classify(client.connectionStatus);
    _setStatus(MqttStatus.failed);
    return false;
  }

  static MqttFailureReason _classify(MqttClientConnectionStatus? status) =>
      _classifyConnectionStatus(status);

  void _listen() {
    _client?.updates?.listen((events) {
      for (final event in events) {
        final recMess = event.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
        final ts = DateTime.now();
        final value = _parseNumeric(payload);
        if (!_rawController.isClosed) {
          _rawController.add(RawMessage(event.topic, payload, value, ts));
        }
        if (value != null) {
          _messageController.add(TopicMessage(event.topic, value, ts));
        }
      }
    });
  }

  /// Accepts a bare number ("23.4") or a JSON object with a "value" field.
  static double? _parseNumeric(String payload) {
    final direct = double.tryParse(payload.trim());
    if (direct != null) return direct;
    final match = RegExp(r'"value"\s*:\s*(-?\d+(\.\d+)?)').firstMatch(payload);
    if (match != null) return double.tryParse(match.group(1)!);
    return null;
  }

  void subscribe(String topic) {
    if (_status == MqttStatus.connected) {
      _client?.subscribe(topic, _qos);
    }
  }

  void unsubscribe(String topic) => _client?.unsubscribe(topic);

  void publish(String topic, String value) {
    if (_status != MqttStatus.connected) return;
    final builder = MqttClientPayloadBuilder()..addString(value);
    _client?.publishMessage(topic, _qos, builder.payload!, retain: _retain);
  }

  Future<void> disconnect() async {
    _client?.disconnect();
    _client = null;
    if (_status != MqttStatus.disconnected) {
      _setStatus(MqttStatus.disconnected);
    }
  }

  void dispose() {
    _client?.disconnect();
    _statusController.close();
    _messageController.close();
    _rawController.close();
  }
}

/// Maps a stored QoS integer (0/1/2) to its [MqttQos]; anything else falls
/// back to QoS 1 (at-least-once).
MqttQos qosFromInt(int qos) => switch (qos) {
      0 => MqttQos.atMostOnce,
      2 => MqttQos.exactlyOnce,
      _ => MqttQos.atLeastOnce,
    };

/// Maps the broker's connect return code to a coarse [MqttFailureReason].
/// A missing/unspecified code means we never got a broker-level reply, which
/// is almost always a network-level problem (host, port, firewall, timeout).
MqttFailureReason _classifyConnectionStatus(
  MqttClientConnectionStatus? status,
) {
  switch (status?.returnCode) {
    case MqttConnectReturnCode.badUsernameOrPassword:
    case MqttConnectReturnCode.notAuthorized:
      return MqttFailureReason.badCredentials;
    case MqttConnectReturnCode.brokerUnavailable:
      return MqttFailureReason.brokerUnavailable;
    case MqttConnectReturnCode.identifierRejected:
    case MqttConnectReturnCode.unacceptedProtocolVersion:
      return MqttFailureReason.rejected;
    case MqttConnectReturnCode.connectionAccepted:
    case MqttConnectReturnCode.noneSpecified:
    case null:
      return MqttFailureReason.network;
  }
}

/// Attempts a one-off connection with the given parameters purely to validate
/// them. Uses its own throwaway client, so it never disturbs a live
/// [MqttService] connection. Returns null on success, or a [MqttFailureReason].
Future<MqttFailureReason?> testBrokerConnection({
  required String address,
  required int port,
  String? username,
  String? password,
  bool secure = false,
  int keepAlive = 20,
  int connectTimeout = 10,
}) async {
  final clientId = 'mqtt_dash_test_${address.hashCode.toUnsigned(16)}';
  final client = MqttServerClient.withPort(address, clientId, port)
    ..secure = secure
    ..keepAlivePeriod = keepAlive
    ..connectTimeoutPeriod = connectTimeout * 1000
    ..autoReconnect = false;

  final connMessage = MqttConnectMessage()
      .withClientIdentifier(clientId)
      .startClean();
  if (username != null && username.isNotEmpty) {
    connMessage.authenticateAs(username, password ?? '');
  }
  client.connectionMessage = connMessage;

  try {
    await client.connect();
  } catch (_) {
    final reason = _classifyConnectionStatus(client.connectionStatus);
    client.disconnect();
    return reason;
  }

  final ok = client.connectionStatus?.state == MqttConnectionState.connected;
  final reason = ok ? null : _classifyConnectionStatus(client.connectionStatus);
  client.disconnect();
  return reason;
}
