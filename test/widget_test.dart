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

  test('day view returns raw readings for the anchored date', () async {
    final brokerRepo = BrokerRepository(db);
    final brokerId = await brokerRepo.insert(BrokersCompanion.insert(
      name: 'b',
      address: 'a',
      port: 1883,
    ));
    final metricId = await db.into(db.metrics).insert(MetricsCompanion.insert(
          brokerId: Value(brokerId),
          name: 'temp',
          topic: 'home/temp',
        ));

    final readings = ReadingRepository(db);
    final day = DateTime(2026, 5, 31, 10);
    await readings.insert(metricId, 20, day);
    await readings.insert(metricId, 30, day.add(const Duration(hours: 1)));
    // A reading on another day must be excluded by the range filter.
    await readings.insert(metricId, 99, DateTime(2026, 6, 1, 10));

    final agg =
        await readings.watchAggregated(metricId, TimeBucket.day, day).first;
    expect(agg.map((p) => p.value), [20, 30]); // both raw points, in order
  });

  test('year view returns raw readings within the anchored year', () async {
    final brokerRepo = BrokerRepository(db);
    final brokerId = await brokerRepo.insert(BrokersCompanion.insert(
      name: 'b',
      address: 'a',
      port: 1883,
    ));
    final metricId = await db.into(db.metrics).insert(MetricsCompanion.insert(
          brokerId: Value(brokerId),
          name: 'temp',
          topic: 'home/temp',
        ));

    final readings = ReadingRepository(db);
    await readings.insert(metricId, 20, DateTime(2026, 5, 10));
    await readings.insert(metricId, 30, DateTime(2026, 9, 20));
    // Different year → excluded from the 2026 window.
    await readings.insert(metricId, 99, DateTime(2025, 5, 10));

    final agg = await readings
        .watchAggregated(metricId, TimeBucket.year, DateTime(2026, 1, 1))
        .first;
    expect(agg.map((p) => p.value), [20, 30]); // raw points, no averaging
  });

  test('cascade delete removes metrics with broker', () async {
    final brokerRepo = BrokerRepository(db);
    final brokerId = await brokerRepo.insert(BrokersCompanion.insert(
      name: 'b',
      address: 'a',
      port: 1883,
    ));
    await db.into(db.metrics).insert(MetricsCompanion.insert(
          brokerId: Value(brokerId),
          name: 'm',
          topic: 't',
          publishEnabled: const Value(true),
        ));

    await brokerRepo.delete(brokerId);
    final remaining = await db.select(db.metrics).get();
    expect(remaining, isEmpty);
  });
}
