import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db/database.dart';
import '../data/repositories/broker_repository.dart';
import '../data/repositories/metric_repository.dart';
import '../data/repositories/reading_repository.dart';
import 'mqtt_service.dart';

/// SharedPreferences keys used to hand state across the isolate boundary. The
/// background isolate has no Riverpod/BuildContext, so the UI writes what the
/// service needs (which broker, localized notification text) to prefs before
/// starting it — the same prefs-as-transport pattern the SMS background handler
/// relies on.
const kBgKeepConnected = 'bg_keep_connected';
const kBgActiveBrokerId = 'bg_active_broker_id';
const kBgNotifTitle = 'bg_notif_title';
const kBgNotifBody = 'bg_notif_body';

const _notificationChannelId = 'mqtt_dash_bg';
const _notificationId = 1971;

/// Registers the foreground-service notification channel and configures the
/// background service. Called once from `main()` on Android. `autoStart` is off:
/// the service is started on demand only when background mode is on and a broker
/// is connected (see the lifecycle observer in `AppShell`).
Future<void> initializeBackgroundService() async {
  const channel = AndroidNotificationChannel(
    _notificationChannelId,
    'Background connection',
    description: 'Keeps the MQTT broker connected while the app is closed.',
    importance: Importance.low,
  );

  final notifications = FlutterLocalNotificationsPlugin();
  await notifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      // Never let Android restart the service on boot. It spins up a second
      // Flutter engine whose plugin registration hijacks `another_telephony`'s
      // process-global foreground SMS channel, silently dropping incoming SMS.
      // The service must start ONLY via the explicit background-mode handoff
      // (see AppShell), never on its own.
      autoStartOnBoot: false,
      isForegroundMode: true,
      notificationChannelId: _notificationChannelId,
      foregroundServiceNotificationId: _notificationId,
      foregroundServiceTypes: [AndroidForegroundType.dataSync],
    ),
    iosConfiguration: IosConfiguration(autoStart: false),
  );
}

/// Background-isolate entry point. Must stay top-level and annotated so the
/// tree-shaker keeps it in release builds.
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final runner = BackgroundMqttRunner(service);

  // The UI asks the service to stop by invoking 'stop' (e.g. on foreground or
  // when the toggle is turned off).
  service.on('stop').listen((_) async {
    await runner.stop();
    await service.stopSelf();
  });

  await runner.start();
}

/// Owns the MQTT connection and reading persistence while the app is not in the
/// foreground. Mirrors [MqttService] + `ConnectionController._onMessage`, but
/// runs in the service isolate against its own [AppDatabase] connection to the
/// shared `mqtt_dash` database file.
class BackgroundMqttRunner {
  BackgroundMqttRunner(this._service);

  final ServiceInstance _service;

  AppDatabase? _db;
  MqttService? _mqtt;
  StreamSubscription? _msgSub;
  final Map<String, int> _topicToMetric = {};

  Future<void> start() async {
    if (_service is AndroidServiceInstance) {
      await (_service).setAsForegroundService();
    }

    final prefs = await SharedPreferences.getInstance();
    final brokerId = prefs.getInt(kBgActiveBrokerId);
    if (brokerId == null) {
      await _service.stopSelf();
      return;
    }

    final db = AppDatabase();
    _db = db;
    final brokerRepo = BrokerRepository(db);
    final metricRepo = MetricRepository(db);
    final readingRepo = ReadingRepository(db);

    final Broker broker;
    try {
      broker = await brokerRepo.getById(brokerId);
    } catch (_) {
      await stop();
      await _service.stopSelf();
      return;
    }

    final mqtt = MqttService();
    _mqtt = mqtt;
    _msgSub = mqtt.messages.listen((msg) {
      final metricId = _topicToMetric[msg.topic];
      if (metricId == null) return;
      readingRepo.insert(metricId, msg.value, msg.timestamp, raw: msg.raw);
    });

    final ok = await mqtt.connect(broker, clientIdSuffix: 'bg');
    if (!ok) {
      await stop();
      await _service.stopSelf();
      return;
    }

    final metrics = await metricRepo.getForBroker(brokerId);
    _topicToMetric
      ..clear()
      ..addEntries(metrics.map((m) => MapEntry(m.topic, m.id)));
    for (final m in metrics) {
      mqtt.subscribe(m.topic);
    }

    if (_service is AndroidServiceInstance) {
      await (_service).setForegroundNotificationInfo(
        title: prefs.getString(kBgNotifTitle) ?? 'TEKKIM Dash',
        content: prefs.getString(kBgNotifBody) ?? broker.name,
      );
    }
  }

  Future<void> stop() async {
    await _msgSub?.cancel();
    _msgSub = null;
    _topicToMetric.clear();
    await _mqtt?.disconnect();
    _mqtt?.dispose();
    _mqtt = null;
    await _db?.close();
    _db = null;
  }
}
