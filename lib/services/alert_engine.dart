import '../data/db/database.dart';
import '../data/repositories/alert_repository.dart';

/// Evaluates the alert rules watching a metric against one freshly ingested
/// reading, and records every rule that fires.
///
/// Deliberately Riverpod-free and given a raw [AppDatabase] so all three
/// ingestion paths can share it: `ConnectionController._onMessage` (foreground
/// MQTT), `BackgroundMqttRunner` (service isolate) and `ingestSms` — the same
/// role `sms_ingest.dart` plays for SMS parsing.
///
/// Firing is **once per crossing, per condition**: a condition fires when the
/// value enters its alert zone and then stays silent until the value leaves the
/// zone again. Two conditions on the same rule (say `>= 10` and `>= 20`) each
/// keep their own state, so a value climbing past both fires both, once each.
///
/// Returns the events that fired, so the caller can raise notifications.
Future<List<AlertEvent>> evaluateAlerts(
  AppDatabase db, {
  required int metricId,
  required String metricName,
  required double value,
  required DateTime timestamp,
}) async {
  final repo = AlertRepository(db);
  final rules = await repo.getEnabledForMetric(metricId);
  if (rules.isEmpty) return const [];

  final fired = <AlertEvent>[];
  for (final entry in rules) {
    for (final condition in entry.conditions) {
      final threshold = condition.setpoint + condition.offsetValue;
      final inZone = isInAlertZone(value, threshold, condition.comparison);

      if (inZone && condition.armed) {
        final id = await repo.insertEvent(
          AlertEventsCompanion.insert(
            ruleId: entry.rule.id,
            conditionId: condition.id,
            metricId: metricId,
            ruleName: entry.rule.name,
            metricName: metricName,
            level: condition.level,
            comparison: condition.comparison,
            threshold: threshold,
            value: value,
            triggeredAt: timestamp,
          ),
        );
        await repo.setArmed(condition.id, false);
        fired.add(
          AlertEvent(
            id: id,
            ruleId: entry.rule.id,
            conditionId: condition.id,
            metricId: metricId,
            ruleName: entry.rule.name,
            metricName: metricName,
            level: condition.level,
            comparison: condition.comparison,
            threshold: threshold,
            value: value,
            triggeredAt: timestamp,
          ),
        );
      } else if (!inZone && !condition.armed) {
        // Left the alert zone: re-arm so the next entry fires again.
        await repo.setArmed(condition.id, true);
      }
    }
  }
  return fired;
}

/// Whether [value] satisfies [comparison] against [threshold].
///
/// [AlertComparison.equals] uses an epsilon rather than `==` because readings
/// are doubles. The boolean cases ignore [threshold] entirely and test against
/// zero — see [AlertComparison] for why "active" is non-zero rather than one.
bool isInAlertZone(double value, double threshold, AlertComparison comparison) {
  return switch (comparison) {
    AlertComparison.above => value >= threshold,
    AlertComparison.below => value <= threshold,
    AlertComparison.equals => (value - threshold).abs() < 1e-9,
    AlertComparison.isTrue => value != 0,
    AlertComparison.isFalse => value == 0,
  };
}

/// Whether a comparison describes an on/off metric, so the UI shows an
/// active/inactive picker instead of a setpoint and offset, and readouts drop
/// the meaningless threshold.
bool isBooleanComparison(AlertComparison comparison) =>
    comparison == AlertComparison.isTrue ||
    comparison == AlertComparison.isFalse;

/// The math symbol for an analog comparison, used in notification bodies and
/// inbox rows (`≥ 110`). Boolean comparisons have no symbol — they render as a
/// state name instead, so callers must branch on [isBooleanComparison] first.
String comparisonSymbol(AlertComparison comparison) {
  return switch (comparison) {
    AlertComparison.above => '≥',
    AlertComparison.below => '≤',
    AlertComparison.equals => '=',
    AlertComparison.isTrue || AlertComparison.isFalse => '=',
  };
}

/// ASCII form of [comparisonSymbol], for the PDF export. The `pdf` package's
/// built-in Helvetica has no glyph for `≥`/`≤` and drops them silently, which
/// would turn "≥ 10" into a bare "10" and lose the comparison direction.
String comparisonSymbolAscii(AlertComparison comparison) {
  return switch (comparison) {
    AlertComparison.above => '>=',
    AlertComparison.below => '<=',
    AlertComparison.equals => '=',
    AlertComparison.isTrue || AlertComparison.isFalse => '=',
  };
}
