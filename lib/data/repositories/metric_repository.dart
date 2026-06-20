import 'package:drift/drift.dart';

import '../db/database.dart';

/// CRUD + reactive reads for metrics scoped to a broker.
class MetricRepository {
  MetricRepository(this._db);

  final AppDatabase _db;

  Stream<List<Metric>> watchForBroker(int brokerId) =>
      (_db.select(_db.metrics)
            ..where((m) => m.brokerId.equals(brokerId))
            ..orderBy([(m) => OrderingTerm(expression: m.name)]))
          .watch();

  /// Every metric across all brokers, for the global dashboard chart editor.
  Stream<List<Metric>> watchAll() =>
      (_db.select(_db.metrics)
            ..orderBy([(m) => OrderingTerm(expression: m.name)]))
          .watch();

  Future<List<Metric>> getForBroker(int brokerId) =>
      (_db.select(_db.metrics)..where((m) => m.brokerId.equals(brokerId))).get();

  Future<Metric> getById(int id) =>
      (_db.select(_db.metrics)..where((m) => m.id.equals(id))).getSingle();

  Future<int> insert(MetricsCompanion metric) =>
      _db.into(_db.metrics).insert(metric);

  Future<bool> update(Metric metric) => _db.update(_db.metrics).replace(metric);

  Future<int> delete(int id) =>
      (_db.delete(_db.metrics)..where((m) => m.id.equals(id))).go();
}
