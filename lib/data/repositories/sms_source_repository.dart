import 'package:drift/drift.dart';

import '../db/database.dart';

/// CRUD + reactive reads for SMS data sources.
class SmsSourceRepository {
  SmsSourceRepository(this._db);

  final AppDatabase _db;

  Stream<List<SmsSource>> watchAll() => (_db.select(_db.smsSources)
        ..orderBy([(s) => OrderingTerm(expression: s.name)]))
      .watch();

  Future<List<SmsSource>> getAll() => _db.select(_db.smsSources).get();

  Future<SmsSource> getById(int id) =>
      (_db.select(_db.smsSources)..where((s) => s.id.equals(id))).getSingle();

  Future<int> insert(SmsSourcesCompanion source) =>
      _db.into(_db.smsSources).insert(source);

  Future<bool> update(SmsSource source) =>
      _db.update(_db.smsSources).replace(source);

  Future<int> delete(int id) =>
      (_db.delete(_db.smsSources)..where((s) => s.id.equals(id))).go();

  /// Deep-duplicates a source: inserts a copy of the source row under [newName]
  /// (same sender number) and clones every metric belonging to it. Readings are
  /// not copied. Returns the new source id.
  Future<int> duplicate(int sourceId, String newName) {
    return _db.transaction(() async {
      final src = await getById(sourceId);
      final newId = await insert(
        SmsSourcesCompanion.insert(
          name: newName,
          phoneNumber: src.phoneNumber,
        ),
      );
      final metrics = await (_db.select(_db.metrics)
            ..where((m) => m.smsSourceId.equals(sourceId)))
          .get();
      for (final m in metrics) {
        await _db.into(_db.metrics).insert(
              MetricsCompanion.insert(
                sourceKind: Value(m.sourceKind),
                smsSourceId: Value(newId),
                name: m.name,
                topic: m.topic,
                publishEnabled: Value(m.publishEnabled),
                minValue: Value(m.minValue),
                maxValue: Value(m.maxValue),
                useFixedRange: Value(m.useFixedRange),
                smsValueMode: Value(m.smsValueMode),
              ),
            );
      }
      return newId;
    });
  }
}
