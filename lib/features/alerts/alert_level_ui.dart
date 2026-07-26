import 'package:flutter/material.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../services/alert_engine.dart';
import '../../theme/app_theme.dart';
import '../../utils/number_format.dart';

/// Presentation helpers mapping an [AlertLevel] to its localized label, color
/// and icon, shared by the rule form, the rule list and the alert inbox — so
/// severity reads the same everywhere.
extension AlertLevelUi on AlertLevel {
  String label(AppLocalizations l) => switch (this) {
        AlertLevel.info => l.alertLevelInfo,
        AlertLevel.warning => l.alertLevelWarning,
        AlertLevel.critical => l.alertLevelCritical,
      };

  /// The app's semantic tokens, one per level — blue, amber, red.
  Color get color => switch (this) {
        AlertLevel.info => AppColors.primary,
        AlertLevel.warning => AppColors.warning,
        AlertLevel.critical => AppColors.danger,
      };

  IconData get icon => switch (this) {
        AlertLevel.info => Icons.info_outline,
        AlertLevel.warning => Icons.warning_amber_rounded,
        AlertLevel.critical => Icons.dangerous_outlined,
      };
}

/// Localized label for a comparison mode.
extension AlertComparisonUi on AlertComparison {
  String label(AppLocalizations l) => switch (this) {
        AlertComparison.above => l.comparisonAbove,
        AlertComparison.below => l.comparisonBelow,
        AlertComparison.equals => l.comparisonEquals,
        AlertComparison.isTrue => l.stateYes,
        AlertComparison.isFalse => l.stateNo,
      };
}

/// The trigger condition as a short readout: `≥ 30` for an analog threshold,
/// or the state name (`Yes`) for a yes/no metric, where the stored
/// threshold is meaningless. Shared by the rule list, the rule form's accordion
/// headers and the inbox so a condition reads identically everywhere.
String conditionSummary(
  AlertComparison comparison,
  double threshold,
  String locale,
  AppLocalizations l,
) {
  if (isBooleanComparison(comparison)) return comparison.label(l);
  return '${comparisonSymbol(comparison)} '
      '${formatMetricValue(threshold, locale)}';
}

/// How a fired alert's measurement reads on a card: `temp = 25 (≥ 20)` for an
/// analog metric, `Door = Yes` for a yes/no one — a raw `1`/`3` would tell
/// the user nothing.
String eventReadout(
  AlertEvent event,
  String locale,
  AppLocalizations l,
) {
  if (isBooleanComparison(event.comparison)) {
    return l.alertValueState(event.metricName, event.comparison.label(l));
  }
  return l.alertValueVsThreshold(
    event.metricName,
    formatMetricValue(event.value, locale),
    comparisonSymbol(event.comparison),
    formatMetricValue(event.threshold, locale),
  );
}

/// A small filled circle in a level's color, used as the compact severity
/// marker in rule rows and dropdown items.
class AlertLevelDot extends StatelessWidget {
  const AlertLevelDot({super.key, required this.level, this.size = 10});

  final AlertLevel level;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: level.color, shape: BoxShape.circle),
    );
  }
}
