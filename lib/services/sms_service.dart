import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui' show DartPluginRegistrant;

import 'package:another_telephony/telephony.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:permission_handler/permission_handler.dart';

import '../data/db/database.dart' show AppDatabase;
import 'sms_ingest.dart';

/// A single incoming SMS, normalised for the ingestion pipeline.
class IncomingSms {
  const IncomingSms({
    required this.sender,
    required this.body,
    required this.timestamp,
  });

  /// Raw sender address as reported by the OS (e.g. `+21612345678`).
  final String sender;
  final String body;
  final DateTime timestamp;
}

/// Wraps `another_telephony` to receive incoming SMS on Android. On every other
/// platform (notably iOS, which cannot read SMS at all) all methods are safe
/// no-ops and [isSupported] is false.
class SmsService {
  SmsService([Telephony? telephony])
      : _telephony = telephony ?? (Platform.isAndroid ? Telephony.instance : null);

  final Telephony? _telephony;
  final StreamController<IncomingSms> _controller =
      StreamController<IncomingSms>.broadcast();
  bool _listening = false;

  /// True only where incoming SMS can be read (Android).
  bool get isSupported => Platform.isAndroid;

  /// Broadcast stream of incoming messages (only emits on supported platforms).
  Stream<IncomingSms> get messages => _controller.stream;

  /// Whether SMS read access is currently granted, checked silently (no prompt).
  /// Always false on unsupported platforms. Used to seed the permission banner
  /// so it doesn't reappear when access was granted in a previous session.
  Future<bool> hasPermission() async {
    if (!Platform.isAndroid) return false;
    return Permission.sms.isGranted;
  }

  /// Requests the SMS permissions. Returns true when granted; always false on
  /// unsupported platforms. Only RECEIVE_SMS/READ_SMS are declared in the
  /// manifest, so SEND_SMS is never requested.
  Future<bool> requestPermission() async {
    final t = _telephony;
    if (t == null) return false;
    final granted = await t.requestSmsPermissions;
    return granted ?? false;
  }

  /// Begins listening for incoming SMS. Idempotent; no-op on unsupported
  /// platforms.
  ///
  /// Uses `listenInBackground: true` so messages are delivered to
  /// [smsBackgroundHandler] in a dedicated isolate when the app is backgrounded
  /// or closed. This also sidesteps a plugin conflict: the MQTT
  /// foreground-service spins up a second Flutter engine whose plugin
  /// registration hijacks `another_telephony`'s process-global foreground SMS
  /// channel; routing background delivery through the plugin's own isolate keeps
  /// SMS ingestion working regardless of that engine. Foreground messages still
  /// arrive on [_handle] (the UI isolate) when it owns the channel.
  void startListening() {
    final t = _telephony;
    if (t == null || _listening) return;
    _listening = true;
    t.listenIncomingSms(
      onNewMessage: _handle,
      onBackgroundMessage: smsBackgroundHandler,
      listenInBackground: true,
    );
  }

  void _handle(SmsMessage message) {
    final body = message.body ?? '';
    if (body.isEmpty) return;
    final ts = message.date != null
        ? DateTime.fromMillisecondsSinceEpoch(message.date!)
        : DateTime.now();
    _controller.add(IncomingSms(
      sender: message.address ?? '',
      body: body,
      timestamp: ts,
    ));
  }

  void dispose() => _controller.close();
}

/// Background-isolate entry point for incoming SMS. Runs in `another_telephony`'s
/// own isolate (independent of the UI isolate and the MQTT foreground-service
/// engine), so SMS are parsed and persisted reliably even when the app is
/// backgrounded or closed. Opens its own [AppDatabase] connection to the shared
/// `mqtt_dash` file, mirroring the MQTT background runner.
///
/// Must stay a top-level, annotated function so it survives tree-shaking and can
/// be resolved from the raw callback handle the plugin stores.
@pragma('vm:entry-point')
Future<void> smsBackgroundHandler(SmsMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final body = message.body ?? '';
  if (body.isEmpty) return;
  final ts = message.date != null
      ? DateTime.fromMillisecondsSinceEpoch(message.date!)
      : DateTime.now();
  final db = AppDatabase();
  try {
    await ingestSms(
      db,
      sender: message.address ?? '',
      body: body,
      timestamp: ts,
    );
  } finally {
    await db.close();
  }
}
