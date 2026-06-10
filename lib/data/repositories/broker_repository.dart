import 'package:drift/drift.dart';

import '../db/database.dart';

/// CRUD + reactive reads for brokers.
class BrokerRepository {
  BrokerRepository(this._db);

  final AppDatabase _db;

  Stream<List<Broker>> watchAll() =>
      (_db.select(_db.brokers)..orderBy([(b) => OrderingTerm(expression: b.name)]))
          .watch();

  Future<Broker> getById(int id) =>
      (_db.select(_db.brokers)..where((b) => b.id.equals(id))).getSingle();

  Future<int> insert(BrokersCompanion broker) =>
      _db.into(_db.brokers).insert(broker);

  Future<bool> update(Broker broker) => _db.update(_db.brokers).replace(broker);

  Future<int> delete(int id) =>
      (_db.delete(_db.brokers)..where((b) => b.id.equals(id))).go();
}
