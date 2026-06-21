import 'dart:async';
import 'dart:io' show Platform;

import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

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

  /// Begins foreground listening for incoming SMS. Idempotent; no-op on
  /// unsupported platforms. Background reception is intentionally not enabled.
  void startListening() {
    final t = _telephony;
    if (t == null || _listening) return;
    _listening = true;
    t.listenIncomingSms(
      onNewMessage: _handle,
      listenInBackground: false,
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
