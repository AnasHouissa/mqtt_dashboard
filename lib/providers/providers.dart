import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/db/database.dart';
import '../data/repositories/broker_repository.dart';
import '../data/repositories/dashboard_repository.dart';
import '../data/repositories/metric_repository.dart';
import '../data/repositories/reading_repository.dart';
import '../services/export_service.dart';
import '../services/mqtt_service.dart';

// --- Infrastructure ---

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

final exportServiceProvider = Provider((ref) => ExportService());

final mqttServiceProvider = Provider<MqttService>((ref) {
  final service = MqttService();
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

/// Dashboards are global (not scoped to a broker).
final dashboardsProvider = StreamProvider.autoDispose<List<Dashboard>>((ref) =>
    ref.watch(dashboardRepositoryProvider).watchAll());

final chartsProvider = StreamProvider.autoDispose
    .family<List<ChartWithSeries>, int>((ref, dashboardId) =>
        ref.watch(dashboardRepositoryProvider).watchCharts(dashboardId));

/// Aggregated chart data, keyed by metric + time bucket.
typedef AggKey = ({int metricId, TimeBucket bucket});

final aggregatedProvider = StreamProvider.autoDispose
    .family<List<AggregatedPoint>, AggKey>((ref, key) => ref
        .watch(readingRepositoryProvider)
        .watchAggregated(key.metricId, key.bucket));

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
        .insert(metricId, msg.value, msg.timestamp);
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

// --- App locale ---

class LocaleController extends StateNotifier<Locale?> {
  LocaleController() : super(null); // null => follow system
  void setLocale(Locale? locale) => state = locale;
}

final localeProvider =
    StateNotifierProvider<LocaleController, Locale?>((ref) => LocaleController());

// --- App metadata ---

/// The app's version string (e.g. "1.0.1"), read from the platform package info.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
});
