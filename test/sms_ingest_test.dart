// Integration tests for the shared SMS ingestion path (`ingestSms`), exercised
// by both the foreground controller and the background-isolate handler, against
// a real in-memory Drift database.

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_dash/data/db/database.dart';
import 'package:mqtt_dash/services/sms_ingest.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> seedSource(String phone) => db.into(db.smsSources).insert(
        SmsSourcesCompanion.insert(name: 'qnqs', phoneNumber: phone),
      );

  Future<int> seedMetric(int sourceId, String name, String topic) =>
      db.into(db.metrics).insert(MetricsCompanion.insert(
            sourceKind: Value(MetricSourceKind.sms),
            smsSourceId: Value(sourceId),
            name: name,
            topic: topic,
          ));

  test('DOOR ALERT input list creates a reading with the active count + raw',
      () async {
    final srcId = await seedSource('+21655101214');
    final metricId = await seedMetric(srcId, 'Salle_Serveur_2e_ETG', 'DOOR ALERT');

    final created = await ingestSms(
      db,
      sender: '55101214', // bare local — TnPhone normalises to the same key
      body: 'Salle_Serveur_2e_ETG\nDOOR ALERT [IN1, IN2, IN3]',
      timestamp: DateTime(2026, 7, 11, 12, 0),
    );

    expect(created, 1);
    final readings = await (db.select(db.readings)
          ..where((r) => r.metricId.equals(metricId)))
        .get();
    expect(readings, hasLength(1));
    expect(readings.single.value, 3); // three active inputs
    expect(readings.single.raw, 'IN1, IN2, IN3');

    final log = await db.select(db.smsMessages).get();
    expect(log.single.status, SmsParseStatus.matched);
    expect(log.single.readingsCreated, 1);
  });

  test('[OK] clears the alert (value 0)', () async {
    final srcId = await seedSource('+21655101214');
    await seedMetric(srcId, 'Salle_Serveur_2e_ETG', 'DOOR ALERT');

    await ingestSms(
      db,
      sender: '+21655101214',
      body: 'Salle_Serveur_2e_ETG\nDOOR ALERT [OK]',
      timestamp: DateTime(2026, 7, 11, 12, 5),
    );

    final readings = await db.select(db.readings).get();
    expect(readings.single.value, 0);
    expect(readings.single.raw, 'OK');
  });

  test('message from an untracked number is ignored entirely (not logged)',
      () async {
    final srcId = await seedSource('+21655101214');
    await seedMetric(srcId, 'Salle_Serveur_2e_ETG', 'DOOR ALERT');

    final created = await ingestSms(
      db,
      sender: '+21699999999',
      body: 'Salle_Serveur_2e_ETG\nDOOR ALERT [IN1]',
      timestamp: DateTime(2026, 7, 11, 12, 6),
    );

    expect(created, 0);
    expect(await db.select(db.readings).get(), isEmpty);
    expect(await db.select(db.smsMessages).get(), isEmpty);
  });

  test('tracked sender but no matching metric logs as unmatched, no reading',
      () async {
    final srcId = await seedSource('+21655101214');
    await seedMetric(srcId, 'Salle_Serveur_2e_ETG', 'DOOR ALERT');

    await ingestSms(
      db,
      sender: '+21655101214',
      body: 'Some_Other_Station\nWATER ALERT [IN1]',
      timestamp: DateTime(2026, 7, 11, 12, 7),
    );

    expect(await db.select(db.readings).get(), isEmpty);
    final log = await db.select(db.smsMessages).get();
    expect(log.single.status, SmsParseStatus.unmatched);
    expect(log.single.readingsCreated, 0);
  });
}
