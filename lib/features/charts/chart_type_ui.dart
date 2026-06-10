import 'package:flutter/material.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';

/// Presentation helpers mapping a [ChartType] to its localized label and icon,
/// shared by the series editor and chart cards.
extension ChartTypeUi on ChartType {
  String label(AppLocalizations l) => switch (this) {
        ChartType.line => l.curve,
        ChartType.histogram => l.histogram,
        ChartType.spline => l.spline,
        ChartType.area => l.area,
        ChartType.scatter => l.scatter,
      };

  IconData get icon => switch (this) {
        ChartType.line => Icons.show_chart,
        ChartType.histogram => Icons.bar_chart,
        ChartType.spline => Icons.timeline,
        ChartType.area => Icons.area_chart,
        ChartType.scatter => Icons.scatter_plot,
      };
}
