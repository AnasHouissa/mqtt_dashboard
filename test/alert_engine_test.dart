// Tests for the alert engine's crossing semantics, against an in-memory
// Drift database.

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_dash/data/db/database.dart';
import 'package:mqtt_dash/data/repositories/alert_repository.dart';
import 'package:mqtt_dash/services/alert_engine.dart';

void main() {
  _migrationTests();

  late AppDatabase db;
  late AlertRepository repo;
  late int metricId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = AlertRepository(db);
    final brokerId = await db.into(db.brokers).insert(
          BrokersCompanion.insert(name: 'b', address: 'a', port: 1883),
        );
    metricId = await db.into(db.metrics).insert(
          MetricsCompanion.insert(
            brokerId: Value(brokerId),
            name: 'tank',
            topic: 'home/tank',
          ),
        );
  });

  tearDown(() => db.close());

  /// Feeds one value through the engine and returns the levels that fired.
  Future<List<AlertLevel>> feed(double value) async {
    final fired = await evaluateAlerts(
      db,
      metricId: metricId,
      metricName: 'tank',
      value: value,
      timestamp: DateTime(2026, 1, 1),
    );
    return fired.map((e) => e.level).toList();
  }

  Future<int> saveRule(
    List<AlertConditionDraft> conditions, {
    bool enabled = true,
  }) =>
      repo.saveRule(
        name: 'tank alarm',
        metricId: metricId,
        enabled: enabled,
        conditions: conditions,
      );

  const warningAt10 = AlertConditionDraft(
    setpoint: 10,
    offsetValue: 0,
    comparison: AlertComparison.above,
    level: AlertLevel.warning,
  );
  const criticalAt20 = AlertConditionDraft(
    setpoint: 20,
    offsetValue: 0,
    comparison: AlertComparison.above,
    level: AlertLevel.critical,
  );

  test('fires once per crossing and re-arms only after leaving the zone',
      () async {
    await saveRule([warningAt10]);

    expect(await feed(5), isEmpty, reason: 'below threshold');
    expect(await feed(12), [AlertLevel.warning], reason: 'entered the zone');
    expect(await feed(15), isEmpty, reason: 'still in the zone, disarmed');
    expect(await feed(5), isEmpty, reason: 'left the zone, no event on exit');
    expect(await feed(12), [AlertLevel.warning], reason: 're-armed, fires again');
  });

  test('each level of a rule keeps its own crossing state', () async {
    await saveRule([warningAt10, criticalAt20]);

    expect(await feed(12), [AlertLevel.warning]);
    expect(await feed(25), [AlertLevel.critical],
        reason: 'warning stays disarmed, critical crosses');
    expect(await feed(30), isEmpty);
    expect(await feed(5), isEmpty, reason: 'both re-arm silently');
    expect(await feed(25), [AlertLevel.warning, AlertLevel.critical],
        reason: 'a jump past both thresholds fires both, once each');
  });

  test('offset shifts the threshold', () async {
    await saveRule([
      const AlertConditionDraft(
        setpoint: 100,
        offsetValue: 10,
        comparison: AlertComparison.above,
        level: AlertLevel.critical,
      ),
    ]);

    expect(await feed(105), isEmpty, reason: 'above setpoint, below 110');
    expect(await feed(110), [AlertLevel.critical]);
  });

  test('below comparison fires on the way down', () async {
    await saveRule([
      const AlertConditionDraft(
        setpoint: 5,
        offsetValue: -2,
        comparison: AlertComparison.below,
        level: AlertLevel.warning,
      ),
    ]);

    expect(await feed(10), isEmpty);
    expect(await feed(3), [AlertLevel.warning], reason: '3 <= 5 - 2');
    expect(await feed(1), isEmpty, reason: 'still in the zone');
    expect(await feed(10), isEmpty);
    expect(await feed(3), [AlertLevel.warning]);
  });

  test('equals comparison handles on/off metrics', () async {
    await saveRule([
      const AlertConditionDraft(
        setpoint: 1,
        offsetValue: 0,
        comparison: AlertComparison.equals,
        level: AlertLevel.critical,
      ),
    ]);

    expect(await feed(0), isEmpty);
    expect(await feed(1), [AlertLevel.critical]);
    expect(await feed(1), isEmpty, reason: 'repeated 1 does not re-fire');
    expect(await feed(0), isEmpty, reason: 'back to off, re-arms');
    expect(await feed(1), [AlertLevel.critical]);
  });

  test('isTrue treats any non-zero reading as on', () async {
    await saveRule([
      const AlertConditionDraft(
        setpoint: 0,
        offsetValue: 0,
        comparison: AlertComparison.isTrue,
        level: AlertLevel.critical,
      ),
    ]);

    // An SMS input list parses to the *count* of active inputs, so a door
    // alarm arrives as 1, 3, 4… — never reliably 1. All of them mean "on".
    expect(await feed(0), isEmpty, reason: 'OK / cleared');
    expect(await feed(3), [AlertLevel.critical], reason: '[IN1, IN2, IN4]');
    expect(await feed(1), isEmpty, reason: 'still on, already fired');
    expect(await feed(4), isEmpty, reason: 'more inputs, still one episode');
    expect(await feed(0), isEmpty, reason: 'OK clears and re-arms');
    expect(await feed(1), [AlertLevel.critical], reason: '[IN1] fires again');
  });

  test('isFalse fires when the metric clears', () async {
    await saveRule([
      const AlertConditionDraft(
        setpoint: 0,
        offsetValue: 0,
        comparison: AlertComparison.isFalse,
        level: AlertLevel.info,
      ),
    ]);

    expect(await feed(2), isEmpty, reason: 'active, not the watched state');
    expect(await feed(0), [AlertLevel.info], reason: 'went back to OK');
    expect(await feed(0), isEmpty, reason: 'still OK, already fired');
    expect(await feed(1), isEmpty, reason: 'active again, re-arms');
    expect(await feed(0), [AlertLevel.info]);
  });

  test('boolean conditions ignore the stored threshold', () async {
    // A leftover threshold from a condition switched to on/off must not
    // change behaviour.
    await saveRule([
      const AlertConditionDraft(
        setpoint: 99,
        offsetValue: 5,
        comparison: AlertComparison.isTrue,
        level: AlertLevel.warning,
      ),
    ]);

    expect(await feed(1), [AlertLevel.warning], reason: '1 is on, not < 104');
  });

  test('disabled rules are not evaluated', () async {
    await saveRule([warningAt10], enabled: false);
    expect(await feed(50), isEmpty);
  });

  test('a fired event is recorded unacknowledged with a value snapshot',
      () async {
    await saveRule([warningAt10]);
    await feed(12);

    final events = await repo.watchEvents(acknowledged: false).first;
    expect(events, hasLength(1));
    expect(events.single.ruleName, 'tank alarm');
    expect(events.single.metricName, 'tank');
    expect(events.single.threshold, 10);
    expect(events.single.value, 12);
    expect(events.single.acknowledgedAt, isNull);
    expect(await repo.watchUnacknowledgedCount().first, 1);

    await repo.acknowledge(events.single.id, DateTime(2026, 1, 2));
    expect(await repo.watchUnacknowledgedCount().first, 0);
    expect(await repo.watchEvents(acknowledged: true).first, hasLength(1));
  });

  test('eventsInRange and deleteEventsInRange scope by ack state and window',
      () async {
    await saveRule([warningAt10]);

    // Three events an hour apart, the first two acknowledged.
    for (final hour in [1, 2, 3]) {
      await evaluateAlerts(
        db,
        metricId: metricId,
        metricName: 'tank',
        value: 12,
        timestamp: DateTime(2026, 1, 1, hour),
      );
      await feed(0); // leave the zone so the next value re-fires
    }
    final all = await repo.eventsInRange(acknowledged: false);
    expect(all, hasLength(3));
    await repo.acknowledge(all[0].id, DateTime(2026, 1, 2));
    await repo.acknowledge(all[1].id, DateTime(2026, 1, 2));

    // Unacknowledged events are never returned or deleted by the archive view.
    expect(await repo.eventsInRange(acknowledged: true), hasLength(2));
    expect(await repo.eventsInRange(acknowledged: false), hasLength(1));

    // Window bounds are inclusive and filter on trigger time.
    final windowed = await repo.eventsInRange(
      acknowledged: true,
      start: DateTime(2026, 1, 1, 2),
      end: DateTime(2026, 1, 1, 3),
    );
    expect(windowed, hasLength(1));
    expect(windowed.single.triggeredAt, DateTime(2026, 1, 1, 2));

    final deleted = await repo.deleteEventsInRange(
      acknowledged: true,
      start: DateTime(2026, 1, 1, 2),
      end: DateTime(2026, 1, 1, 3),
    );
    expect(deleted, 1);
    expect(await repo.eventsInRange(acknowledged: true), hasLength(1));
    expect(await repo.eventsInRange(acknowledged: false), hasLength(1),
        reason: 'the outstanding alert is untouched');
  });

  test('unbounded deleteEventsInRange clears only the acknowledged archive',
      () async {
    await saveRule([warningAt10]);
    await feed(12);
    await feed(0);
    await feed(12);

    final events = await repo.eventsInRange(acknowledged: false);
    expect(events, hasLength(2));
    await repo.acknowledge(events.first.id, DateTime(2026, 1, 2));

    expect(await repo.deleteEventsInRange(acknowledged: true), 1);
    expect(await repo.eventsInRange(acknowledged: true), isEmpty);
    expect(await repo.watchUnacknowledgedCount().first, 1);
  });

  test('deleting the metric cascades to rules and events', () async {
    await saveRule([warningAt10]);
    await feed(12);

    await (db.delete(db.metrics)..where((m) => m.id.equals(metricId))).go();

    expect(await repo.watchRulesWithConditions().first, isEmpty);
    expect(await repo.watchEvents(acknowledged: false).first, isEmpty);
  });
}

/// The v12 → v13 migration folded the removed `error` level (index 2) and the
/// old `critical` (index 3) onto the renumbered `critical` (index 2).
void _migrationTests() {
  test('v13 migration renumbers levels off the removed error member', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final brokerId = await db.into(db.brokers).insert(
          BrokersCompanion.insert(name: 'b', address: 'a', port: 1883),
        );
    final metricId = await db.into(db.metrics).insert(
          MetricsCompanion.insert(
            brokerId: Value(brokerId),
            name: 'tank',
            topic: 'home/tank',
          ),
        );
    final ruleId = await db.into(db.alertRules).insert(
          AlertRulesCompanion.insert(name: 'r', metricId: metricId),
        );

    // Write the pre-v13 indices straight past the enum mapping: 2 was `error`,
    // 3 was `critical`. Both must end up as the new critical (2).
    for (final level in [0, 1, 2, 3]) {
      await db.customStatement(
        'INSERT INTO alert_conditions (rule_id, setpoint, offset_value, '
        'comparison, level, position, armed) VALUES (?, 1, 0, 0, ?, 0, 1)',
        [ruleId, level],
      );
    }

    await db.customStatement(
      'UPDATE alert_conditions SET level = 2 WHERE level IN (2, 3)',
    );

    final levels = (await db.select(db.alertConditions).get())
        .map((c) => c.level)
        .toList();
    expect(levels, [
      AlertLevel.info,
      AlertLevel.warning,
      AlertLevel.critical,
      AlertLevel.critical,
    ]);
  });
}
