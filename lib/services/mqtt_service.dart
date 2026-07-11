import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../data/db/database.dart';
import 'sms_parser.dart';

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

/// A parsed numeric message received on a subscribed topic. [raw] carries the
/// original payload (bracket contents for sensor-list payloads) so state
/// components can recover which inputs were active.
class TopicMessage {
  final String topic;
  final double value;
  final DateTime timestamp;
  final String? raw;
  const TopicMessage(this.topic, this.value, this.timestamp, {this.raw});
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

  /// [clientIdSuffix] disambiguates the MQTT client id so the background-service
  /// isolate (which passes `'bg'`) never collides with the UI isolate's client
  /// during a foreground/background handoff — a duplicate id would make the
  /// broker kick one of the two sessions.
  Future<bool> connect(Broker broker, {String? clientIdSuffix}) async {
    await disconnect();

    final clientId = 'mqtt_dash_${broker.id}_'
        '${broker.name.hashCode.toUnsigned(16)}'
        '${clientIdSuffix != null ? '_$clientIdSuffix' : ''}';
    _qos = qosFromInt(broker.qos);
    _retain = broker.retain;

    final client = MqttServerClient.withPort(
      broker.address,
      clientId,
      broker.port,
    );
    client.logging(on: true);
    // Speak MQTT 3.1.1 (protocol name "MQTT", version 4). The library defaults
    // to the legacy MQTT 3.1 "MQIsdp" header, which modern brokers such as
    // test.mosquitto.org reject by resetting the connection.
    client.setProtocolV311();
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
          _messageController.add(
            TopicMessage(event.topic, value, ts, raw: payload),
          );
          continue;
        }
        // Non-numeric: accept sensor-list payloads (e.g. `IN1, IN2` / `[OK]`)
        // so sensor-grid components work over MQTT. Stored value is the active
        // count; the raw list is kept so the grid knows which inputs fired.
        final sensor = _parseSensor(payload);
        if (sensor != null) {
          _messageController.add(
            TopicMessage(event.topic, sensor.count.toDouble(), ts,
                raw: sensor.raw),
          );
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

  /// Interprets a non-numeric payload as a sensor-input list. Strips optional
  /// surrounding `[ ]`, then treats it as active if it names any `INx` token or
  /// is an explicit cleared token (`OK`/`NONE`/`CLEAR`). Returns null for
  /// anything else, so ordinary text messages are still ignored.
  static ({int count, String raw})? _parseSensor(String payload) {
    var body = payload.trim();
    final bracket = RegExp(r'\[([^\]]*)\]\s*$').firstMatch(body);
    if (bracket != null) body = bracket.group(1)!.trim();
    final active = SmsParser.activeInputs(body);
    final upper = body.toUpperCase();
    final cleared = upper == 'OK' || upper == 'NONE' || upper == 'CLEAR';
    if (active.isEmpty && !cleared) return null;
    return (count: active.length, raw: body);
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
    ..setProtocolV311() // MQTT 3.1.1, not the legacy MQIsdp header
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
