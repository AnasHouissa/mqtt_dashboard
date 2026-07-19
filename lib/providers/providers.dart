import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db/database.dart';
import '../data/repositories/broker_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/metric_repository.dart';
import '../data/repositories/reading_repository.dart';
import '../data/repositories/sms_message_repository.dart';
import '../data/repositories/sms_source_repository.dart';
import '../data/repositories/sms_topic_preset_repository.dart';
import '../services/alert_stats.dart';
import '../services/background_service.dart';
import '../services/export_service.dart';
import '../services/mqtt_service.dart';
import '../services/sms_ingest.dart';
import '../services/sms_service.dart';
import '../services/sql_export_service.dart';

// --- Infrastructure ---

/// The app's root navigator key. Wired onto [MaterialApp.navigatorKey] so
/// widgets living in `MaterialApp.builder` (which sit *above* the Navigator,
/// e.g. the connection status bar) can still push routes/sheets by using this
/// navigator's own context.
final rootNavigatorKey = GlobalKey<NavigatorState>();

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final brokerRepositoryProvider = Provider(
    (ref) => BrokerRepository(ref.watch(databaseProvider)));
final metricRepositoryProvider = Provider(
    (ref) => MetricRepository(ref.watch(databaseProvider)));
final dashboardRepositoryProvider = Provider(
    (ref) => DashboardRepository(ref.watch(databaseProvider)));
final readingRepositoryProvider = Provider(
    (ref) => ReadingRepository(ref.watch(databaseProvider)));
final smsSourceRepositoryProvider = Provider(
    (ref) => SmsSourceRepository(ref.watch(databaseProvider)));
final smsMessageRepositoryProvider = Provider(
    (ref) => SmsMessageRepository(ref.watch(databaseProvider)));
final smsTopicPresetRepositoryProvider = Provider(
    (ref) => SmsTopicPresetRepository(ref.watch(databaseProvider)));

final exportServiceProvider = Provider((ref) => ExportService());

final sqlExportServiceProvider =
    Provider((ref) => SqlExportService(ref.watch(databaseProvider)));

final mqttServiceProvider = Provider<MqttService>((ref) {
  final service = MqttService();
  ref.onDispose(service.dispose);
  return service;
});

final smsServiceProvider = Provider<SmsService>((ref) {
  final service = SmsService();
  ref.onDispose(service.dispose);
  return service;
});

// --- Reactive data streams ---

final brokersProvider = StreamProvider.autoDispose((ref) =>
    ref.watch(brokerRepositoryProvider).watchAll());

final metricsProvider =
    StreamProvider.autoDispose.family<List<Metric>, int>((ref, brokerId) =>
        ref.watch(metricRepositoryProvider).watchForBroker(brokerId));

/// Every metric across all brokers — used by the global dashboard chart editor.
final allMetricsProvider = StreamProvider.autoDispose<List<Metric>>((ref) =>
    ref.watch(metricRepositoryProvider).watchAll());

/// All SMS data sources.
final smsSourcesProvider = StreamProvider.autoDispose((ref) =>
    ref.watch(smsSourceRepositoryProvider).watchAll());

/// Reusable SMS topic presets, offered as a dropdown in the SMS metric form
/// and managed from Settings.
final smsTopicPresetsProvider =
    StreamProvider.autoDispose<List<SmsTopicPreset>>((ref) =>
        ref.watch(smsTopicPresetRepositoryProvider).watchAll());

/// Metrics belonging to one SMS source.
final smsMetricsProvider =
    StreamProvider.autoDispose.family<List<Metric>, int>((ref, smsSourceId) =>
        ref.watch(metricRepositoryProvider).watchForSmsSource(smsSourceId));

/// Raw-log messages for one SMS source (debug inbox).
final smsMessagesProvider = StreamProvider.autoDispose
    .family<List<SmsMessage>, int>((ref, smsSourceId) =>
        ref.watch(smsMessageRepositoryProvider).watchForSource(smsSourceId));

/// Dashboards are global (not scoped to a broker).
final dashboardsProvider = StreamProvider.autoDispose<List<Dashboard>>((ref) =>
    ref.watch(dashboardRepositoryProvider).watchAll());

final chartsProvider = StreamProvider.autoDispose
    .family<List<ChartWithSeries>, int>((ref, dashboardId) =>
        ref.watch(dashboardRepositoryProvider).watchCharts(dashboardId));

/// Aggregated chart data, keyed by metric + time bucket + the selected period.
/// [anchor] must be normalized to the period start by the caller so identical
/// selections share a cache entry (records compare by value).
///
/// [startMinutes]/[endMinutes] optionally narrow a **day** bucket to a time
/// window within that day (minutes from midnight); null on both = the whole
/// day. Ignored for month/year buckets.
typedef AggKey = ({
  int metricId,
  TimeBucket bucket,
  DateTime anchor,
  int? startMinutes,
  int? endMinutes,
});

final aggregatedProvider = StreamProvider.autoDispose
    .family<List<AggregatedPoint>, AggKey>((ref, key) => ref
        .watch(readingRepositoryProvider)
        .watchAggregated(
          key.metricId,
          key.bucket,
          key.anchor,
          startMinutes: key.startMinutes,
          endMinutes: key.endMinutes,
        ));

/// The latest reading for a metric, used by "current-state" components (sensor
/// grid / stat tile). Null until the first message for that metric arrives.
final latestReadingProvider = StreamProvider.autoDispose
    .family<Reading?, int>((ref, metricId) =>
        ref.watch(readingRepositoryProvider).watchLatest(metricId));

/// Average of today's readings for a metric, shown on the stat tile. Null until
/// the first reading of the day arrives.
final dailyAverageProvider = StreamProvider.autoDispose
    .family<double?, int>((ref, metricId) =>
        ref.watch(readingRepositoryProvider).watchDailyAverage(metricId));

/// Minimum of today's readings for a metric, shown on the stat tile when
/// enabled. Null until the first reading of the day arrives.
final dailyMinProvider = StreamProvider.autoDispose
    .family<double?, int>((ref, metricId) =>
        ref.watch(readingRepositoryProvider).watchDailyMin(metricId));

/// Maximum of today's readings for a metric, shown on the stat tile when
/// enabled. Null until the first reading of the day arrives.
final dailyMaxProvider = StreamProvider.autoDispose
    .family<double?, int>((ref, metricId) =>
        ref.watch(readingRepositoryProvider).watchDailyMax(metricId));

/// Alert-duration stats for a metric over the selected period, used by the
/// alert-duration component. Keyed like [aggregatedProvider].
final alertDurationProvider = StreamProvider.autoDispose
    .family<AlertDurationStats, AggKey>((ref, key) => ref
        .watch(readingRepositoryProvider)
        .watchAlertDuration(key.metricId, key.bucket, key.anchor));

// --- Device connectivity ---

/// Whether the device currently has a network connection. Drives the global
/// "no internet" overlay. Emits the current state immediately, then updates as
/// connectivity changes. Defaults to online while the first check is pending.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  bool isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
  yield isOnline(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(isOnline);
});

// --- Active connection ---

/// Tracks the currently connected broker, subscribes to its metrics, and
/// persists every incoming numeric message as a reading.
class ConnectionController extends StateNotifier<MqttStatus> {
  ConnectionController(this._ref) : super(MqttStatus.disconnected) {
    final service = _ref.read(mqttServiceProvider);
    _statusSub = service.statusStream.listen((s) => state = s);
    _msgSub = service.messages.listen(_onMessage);
  }

  final Ref _ref;
  StreamSubscription? _statusSub;
  StreamSubscription? _msgSub;
  int? activeBrokerId;

  /// topic -> metricId, for routing incoming messages to the right metric.
  final Map<String, int> _topicToMetric = {};

  /// Why the last [connect] failed; null when not in a failed state.
  MqttFailureReason? get lastFailureReason =>
      _ref.read(mqttServiceProvider).lastFailureReason;

  /// Returns true on success. On failure, [lastFailureReason] explains why.
  /// Callers must use this return value rather than reading [connectionProvider]
  /// immediately after, because the status stream delivers asynchronously and
  /// the provider would still hold the stale `connecting` value.
  Future<bool> connect(Broker broker) async {
    final service = _ref.read(mqttServiceProvider);
    // Claim active *before* awaiting so the UI recognises this broker as the
    // active one while the handshake is in flight and can render `connecting`.
    activeBrokerId = broker.id;
    final ok = await service.connect(broker);
    if (!ok) {
      activeBrokerId = null;
      return false;
    }

    final metrics =
        await _ref.read(metricRepositoryProvider).getForBroker(broker.id);
    _topicToMetric
      ..clear()
      ..addEntries(metrics.map((m) => MapEntry(m.topic, m.id)));
    for (final m in metrics) {
      service.subscribe(m.topic);
    }
    return true;
  }

  /// Re-sync subscriptions after metrics change for the active broker.
  Future<void> refreshSubscriptions() async {
    final brokerId = activeBrokerId;
    if (brokerId == null || state != MqttStatus.connected) return;
    final service = _ref.read(mqttServiceProvider);
    final metrics =
        await _ref.read(metricRepositoryProvider).getForBroker(brokerId);
    final newTopics = {for (final m in metrics) m.topic: m.id};

    for (final topic in _topicToMetric.keys) {
      if (!newTopics.containsKey(topic)) service.unsubscribe(topic);
    }
    for (final entry in newTopics.entries) {
      if (!_topicToMetric.containsKey(entry.key)) {
        service.subscribe(entry.key);
      }
    }
    _topicToMetric
      ..clear()
      ..addAll(newTopics);
  }

  void publish(String topic, String value) =>
      _ref.read(mqttServiceProvider).publish(topic, value);

  void _onMessage(TopicMessage msg) {
    final metricId = _topicToMetric[msg.topic];
    if (metricId == null) return;
    _ref
        .read(readingRepositoryProvider)
        .insert(metricId, msg.value, msg.timestamp, raw: msg.raw);
  }

  Future<void> disconnect() async {
    await _ref.read(mqttServiceProvider).disconnect();
    activeBrokerId = null;
    _topicToMetric.clear();
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _msgSub?.cancel();
    super.dispose();
  }
}

final connectionProvider =
    StateNotifierProvider<ConnectionController, MqttStatus>(
        (ref) => ConnectionController(ref));

// --- SMS ingestion ---

/// Listens to incoming SMS, routes each message from a tracked sender number to
/// its [SmsSource], parses it, persists matching values as readings, and logs
/// every message (matched or not) to the raw inbox. The SMS analogue of
/// [ConnectionController] — but with no connect step: it just listens.
class SmsIngestionController {
  SmsIngestionController(this._ref) {
    final service = _ref.read(smsServiceProvider);
    _sub = service.messages.listen(_onSms);
    // Register the foreground receiver eagerly (no-op until permission is
    // granted, and a no-op on non-Android platforms).
    service.startListening();
  }

  final Ref _ref;
  StreamSubscription<IncomingSms>? _sub;

  /// Foreground delivery: ingest against the UI's shared database so Drift's
  /// reactive streams refresh live. Backgrounded/closed messages are handled by
  /// `smsBackgroundHandler` in the plugin's own isolate (see [SmsService]).
  Future<void> _onSms(IncomingSms sms) async {
    await ingestSms(
      _ref.read(databaseProvider),
      sender: sms.sender,
      body: sms.body,
      timestamp: sms.timestamp,
    );
  }

  void dispose() => _sub?.cancel();
}

/// Eagerly created at app start so SMS listening begins as soon as permission
/// allows. Read once during app init to instantiate it.
final smsIngestionProvider = Provider<SmsIngestionController>((ref) {
  final controller = SmsIngestionController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

/// Whether the SMS permission has been granted this session. The UI calls
/// [SmsPermissionController.request] to prompt and starts listening on grant.
class SmsPermissionController extends StateNotifier<bool> {
  SmsPermissionController(this._ref) : super(false) {
    // Seed from the OS so the banner stays hidden when access was already
    // granted (in a prior session or via system settings).
    refresh();
  }

  final Ref _ref;

  bool get isSupported => _ref.read(smsServiceProvider).isSupported;

  /// Re-syncs state with the current OS permission status without prompting.
  /// Call on app resume so granting via system settings reflects immediately.
  Future<void> refresh() async {
    final granted = await _ref.read(smsServiceProvider).hasPermission();
    if (mounted) state = granted;
  }

  Future<bool> request() async {
    final service = _ref.read(smsServiceProvider);
    final granted = await service.requestPermission();
    state = granted;
    if (granted) service.startListening();
    return granted;
  }
}

final smsPermissionProvider =
    StateNotifierProvider<SmsPermissionController, bool>(
        (ref) => SmsPermissionController(ref));

// --- App locale ---

/// Holds the [SharedPreferences] instance. Overridden in `main()` once prefs
/// have loaded, so it can be read synchronously everywhere else.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

/// Persisted app-locale selection. `null` means "follow the system locale".
/// The chosen language code is stored under [_localeKey] so it survives
/// restarts.
class LocaleController extends StateNotifier<Locale?> {
  LocaleController(this._prefs) : super(_read(_prefs));

  static const _localeKey = 'app_locale';

  final SharedPreferences _prefs;

  static Locale? _read(SharedPreferences prefs) {
    final code = prefs.getString(_localeKey);
    return code == null ? null : Locale(code);
  }

  void setLocale(Locale? locale) {
    state = locale;
    if (locale == null) {
      _prefs.remove(_localeKey);
    } else {
      _prefs.setString(_localeKey, locale.languageCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleController, Locale?>(
  (ref) => LocaleController(ref.watch(sharedPreferencesProvider)),
);

// --- Background mode (Android) ---

/// Persisted "keep brokers connected in background" preference plus the
/// start/stop control of the foreground service that hosts the background MQTT
/// connection. State is the toggle value; default OFF (it drains battery).
///
/// The service runs in its own isolate with no access to Riverpod, so the
/// broker to connect and the localized notification text are handed across via
/// SharedPreferences (see keys in `background_service.dart`).
class BackgroundServiceController extends StateNotifier<bool> {
  BackgroundServiceController(this._prefs)
      : super(_prefs.getBool(kBgKeepConnected) ?? false);

  final SharedPreferences _prefs;

  Future<void> setKeepConnected(bool value) async {
    state = value;
    await _prefs.setBool(kBgKeepConnected, value);
    // Turning it off should tear down a running service immediately.
    if (!value && await FlutterBackgroundService().isRunning()) {
      FlutterBackgroundService().invoke('stop');
      await _prefs.remove(kBgActiveBrokerId);
    }
  }

  /// Persists the target broker + localized notification strings, then starts
  /// the foreground service. Called from the app lifecycle observer when the app
  /// is backgrounded while a broker is connected.
  Future<void> startForBroker(
    int brokerId, {
    required String notifTitle,
    required String notifBody,
  }) async {
    await _prefs.setInt(kBgActiveBrokerId, brokerId);
    await _prefs.setString(kBgNotifTitle, notifTitle);
    await _prefs.setString(kBgNotifBody, notifBody);
    await FlutterBackgroundService().startService();
  }

  /// Stops the service (if running) and forgets the target broker.
  Future<void> stop() async {
    if (await FlutterBackgroundService().isRunning()) {
      FlutterBackgroundService().invoke('stop');
    }
    await _prefs.remove(kBgActiveBrokerId);
  }
}

final backgroundServiceProvider =
    StateNotifierProvider<BackgroundServiceController, bool>(
        (ref) => BackgroundServiceController(ref.watch(sharedPreferencesProvider)));

// --- App metadata ---

/// The app's version string (e.g. "1.0.1"), read from the platform package info.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
});
