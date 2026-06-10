// Tests for the persistence layer using an in-memory Drift database.

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_dash/data/db/database.dart';
import 'package:mqtt_dash/data/repositories/broker_repository.dart';
import 'package:mqtt_dash/data/repositories/reading_repository.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('insert and read a broker', () async {
    final repo = BrokerRepository(db);
    final id = await repo.insert(BrokersCompanion.insert(
      name: 'Local',
      address: 'test.mosquitto.org',
      port: 1883,
    ));
    final broker = await repo.getById(id);
    expect(broker.name, 'Local');
    expect(broker.port, 1883);
  });

  test('aggregates readings by day', () async {
    final brokerRepo = BrokerRepository(db);
    final brokerId = await brokerRepo.insert(BrokersCompanion.insert(
      name: 'b',
      address: 'a',
      port: 1883,
    ));
    final metricId = await db.into(db.metrics).insert(MetricsCompanion.insert(
          brokerId: brokerId,
          name: 'temp',
          topic: 'home/temp',
        ));

    final readings = ReadingRepository(db);
    final day = DateTime(2026, 5, 31, 10);
    await readings.insert(metricId, 20, day);
    await readings.insert(metricId, 30, day.add(const Duration(hours: 1)));

    final agg = await readings.watchAggregated(metricId, TimeBucket.day).first;
    expect(agg.length, 1);
    expect(agg.first.value, 25); // average of 20 and 30
  });

  test('cascade delete removes metrics with broker', () async {
    final brokerRepo = BrokerRepository(db);
    final brokerId = await brokerRepo.insert(BrokersCompanion.insert(
      name: 'b',
      address: 'a',
      port: 1883,
    ));
    await db.into(db.metrics).insert(MetricsCompanion.insert(
          brokerId: brokerId,
          name: 'm',
          topic: 't',
          publishEnabled: const Value(true),
        ));

    await brokerRepo.delete(brokerId);
    final remaining = await db.select(db.metrics).get();
    expect(remaining, isEmpty);
  });
}
