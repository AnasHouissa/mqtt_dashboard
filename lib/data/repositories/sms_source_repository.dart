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
}
