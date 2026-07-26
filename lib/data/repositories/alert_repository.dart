import 'package:drift/drift.dart';

import '../db/database.dart';

/// CRUD + reactive reads for alert rules, their conditions, and the inbox of
/// fired alert events.
class AlertRepository {
  AlertRepository(this._db);

  final AppDatabase _db;

  // --- Rules ---

  /// Watch every rule with its metric and ordered conditions. A rule always has
  /// ≥1 condition (the form enforces it), so the inner join never hides a rule.
  Stream<List<AlertRuleWithConditions>> watchRulesWithConditions() {
    final query =
        _db.select(_db.alertRules).join([
            innerJoin(
              _db.metrics,
              _db.metrics.id.equalsExp(_db.alertRules.metricId),
            ),
            innerJoin(
              _db.alertConditions,
              _db.alertConditions.ruleId.equalsExp(_db.alertRules.id),
            ),
          ])
          ..orderBy([
            OrderingTerm(expression: _db.alertRules.name),
            OrderingTerm(expression: _db.alertRules.id),
            OrderingTerm(expression: _db.alertConditions.position),
          ]);

    return query.watch().map((rows) {
      // Preserve rule order while grouping conditions under each rule.
      final byRule = <int, AlertRuleWithConditions>{};
      for (final row in rows) {
        final rule = row.readTable(_db.alertRules);
        final entry = byRule.putIfAbsent(
          rule.id,
          () => AlertRuleWithConditions(
            rule: rule,
            metric: row.readTable(_db.metrics),
            conditions: [],
          ),
        );
        entry.conditions.add(row.readTable(_db.alertConditions));
      }
      return byRule.values.toList();
    });
  }

  /// Enabled rules watching [metricId], each with its ordered conditions. Used
  /// by the alert engine on every incoming reading, so it is a plain future
  /// (not a stream) and runs in whichever isolate ingested the value.
  Future<List<AlertRuleWithConditions>> getEnabledForMetric(int metricId) async {
    final query =
        _db.select(_db.alertRules).join([
            innerJoin(
              _db.metrics,
              _db.metrics.id.equalsExp(_db.alertRules.metricId),
            ),
            innerJoin(
              _db.alertConditions,
              _db.alertConditions.ruleId.equalsExp(_db.alertRules.id),
            ),
          ])
          ..where(
            _db.alertRules.metricId.equals(metricId) &
                _db.alertRules.enabled.equals(true),
          )
          ..orderBy([OrderingTerm(expression: _db.alertConditions.position)]);

    final byRule = <int, AlertRuleWithConditions>{};
    for (final row in await query.get()) {
      final rule = row.readTable(_db.alertRules);
      final entry = byRule.putIfAbsent(
        rule.id,
        () => AlertRuleWithConditions(
          rule: rule,
          metric: row.readTable(_db.metrics),
          conditions: [],
        ),
      );
      entry.conditions.add(row.readTable(_db.alertConditions));
    }
    return byRule.values.toList();
  }

  /// Create or update a rule and replace its conditions atomically. Pass
  /// [ruleId] to edit an existing rule; leave it null to create one.
  ///
  /// Conditions are deleted and re-inserted rather than diffed, which resets
  /// their [AlertConditions.armed] state — intended, since editing a threshold
  /// invalidates the previous crossing state. Past [AlertEvents] rows are
  /// preserved by their denormalized rule/metric names.
  Future<int> saveRule({
    int? ruleId,
    required String name,
    required int metricId,
    required bool enabled,
    required List<AlertConditionDraft> conditions,
  }) {
    return _db.transaction(() async {
      final int id;
      if (ruleId == null) {
        id = await _db.into(_db.alertRules).insert(
              AlertRulesCompanion.insert(
                name: name,
                metricId: metricId,
                enabled: Value(enabled),
              ),
            );
      } else {
        id = ruleId;
        await (_db.update(_db.alertRules)..where((r) => r.id.equals(id))).write(
          AlertRulesCompanion(
            name: Value(name),
            metricId: Value(metricId),
            enabled: Value(enabled),
          ),
        );
        await (_db.delete(_db.alertConditions)
              ..where((c) => c.ruleId.equals(id)))
            .go();
      }

      for (var i = 0; i < conditions.length; i++) {
        final c = conditions[i];
        await _db.into(_db.alertConditions).insert(
              AlertConditionsCompanion.insert(
                ruleId: id,
                setpoint: c.setpoint,
                offsetValue: Value(c.offsetValue),
                comparison: Value(c.comparison),
                level: c.level,
                position: Value(i),
              ),
            );
      }
      return id;
    });
  }

  Future<void> setEnabled(int ruleId, bool enabled) =>
      (_db.update(_db.alertRules)..where((r) => r.id.equals(ruleId)))
          .write(AlertRulesCompanion(enabled: Value(enabled)));

  Future<int> deleteRule(int ruleId) =>
      (_db.delete(_db.alertRules)..where((r) => r.id.equals(ruleId))).go();

  // --- Conditions ---

  /// Flip a condition's crossing state (see [AlertConditions.armed]).
  Future<void> setArmed(int conditionId, bool armed) =>
      (_db.update(_db.alertConditions)..where((c) => c.id.equals(conditionId)))
          .write(AlertConditionsCompanion(armed: Value(armed)));

  // --- Events (inbox) ---

  /// Fired alerts, newest first, split by whether they have been acknowledged.
  Stream<List<AlertEvent>> watchEvents({required bool acknowledged}) {
    final query = _db.select(_db.alertEvents)
      ..where((e) => acknowledged
          ? e.acknowledgedAt.isNotNull()
          : e.acknowledgedAt.isNull())
      ..orderBy([
        (e) => OrderingTerm(
              expression: acknowledged ? e.acknowledgedAt : e.triggeredAt,
              mode: OrderingMode.desc,
            ),
      ]);
    return query.watch();
  }

  /// Live count of unacknowledged alerts — drives the bottom-nav badge.
  Stream<int> watchUnacknowledgedCount() {
    final count = _db.alertEvents.id.count();
    final query = _db.selectOnly(_db.alertEvents)
      ..addColumns([count])
      ..where(_db.alertEvents.acknowledgedAt.isNull());
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  /// Events of one acknowledgement state within `[start, end]` (inclusive;
  /// a null bound means unbounded on that side), oldest first — the shape
  /// CSV/PDF export wants. Mirrors [ReadingRepository.rawForMetric].
  Future<List<AlertEvent>> eventsInRange({
    required bool acknowledged,
    DateTime? start,
    DateTime? end,
  }) {
    final query = _db.select(_db.alertEvents)
      ..where((e) => acknowledged
          ? e.acknowledgedAt.isNotNull()
          : e.acknowledgedAt.isNull())
      ..orderBy([(e) => OrderingTerm(expression: e.triggeredAt)]);
    if (start != null) {
      query.where((e) => e.triggeredAt.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      query.where((e) => e.triggeredAt.isSmallerOrEqualValue(end));
    }
    return query.get();
  }

  /// Deletes events of one acknowledgement state within `[start, end]`
  /// (inclusive; null bound = unbounded). Returns the number of rows removed;
  /// the inbox refreshes automatically. Pass no bounds to clear them all.
  Future<int> deleteEventsInRange({
    required bool acknowledged,
    DateTime? start,
    DateTime? end,
  }) {
    final query = _db.delete(_db.alertEvents)
      ..where((e) => acknowledged
          ? e.acknowledgedAt.isNotNull()
          : e.acknowledgedAt.isNull());
    if (start != null) {
      query.where((e) => e.triggeredAt.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      query.where((e) => e.triggeredAt.isSmallerOrEqualValue(end));
    }
    return query.go();
  }

  Future<int> insertEvent(AlertEventsCompanion event) =>
      _db.into(_db.alertEvents).insert(event);

  Future<void> acknowledge(int eventId, DateTime at) =>
      (_db.update(_db.alertEvents)..where((e) => e.id.equals(eventId)))
          .write(AlertEventsCompanion(acknowledgedAt: Value(at)));

  /// Acknowledge every outstanding alert at once.
  Future<void> acknowledgeAll(DateTime at) =>
      (_db.update(_db.alertEvents)..where((e) => e.acknowledgedAt.isNull()))
          .write(AlertEventsCompanion(acknowledgedAt: Value(at)));
}

/// A rule joined to its watched metric and its ordered conditions.
class AlertRuleWithConditions {
  final AlertRule rule;
  final Metric metric;
  final List<AlertCondition> conditions;
  const AlertRuleWithConditions({
    required this.rule,
    required this.metric,
    required this.conditions,
  });
}

/// Plain value object describing a condition to save, before it has an id.
class AlertConditionDraft {
  final double setpoint;
  final double offsetValue;
  final AlertComparison comparison;
  final AlertLevel level;
  const AlertConditionDraft({
    required this.setpoint,
    required this.offsetValue,
    required this.comparison,
    required this.level,
  });

  /// The effective threshold this condition fires at.
  double get threshold => setpoint + offsetValue;
}
