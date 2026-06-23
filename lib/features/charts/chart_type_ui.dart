import 'package:flutter/material.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';

/// Presentation helpers mapping a [ChartType] to its localized label and icon,
/// shared by the series editor and chart cards.
extension ChartTypeUi on ChartType {
  String label(AppLocalizations l) => switch (this) {
        ChartType.column => l.column,
        ChartType.bar => l.bar,
        ChartType.rangeArea => l.rangeArea,
        ChartType.stackedColumn => l.stackedColumn,
        ChartType.stackedBar => l.stackedBar,
        ChartType.stackedColumn100 => l.stackedColumn100,
        ChartType.histogram => l.histogram,
        ChartType.boxAndWhisker => l.boxAndWhisker,
        ChartType.radialBar => l.radialBar,
        ChartType.doughnut => l.doughnut,
        ChartType.pie => l.pie,
        ChartType.errorBar => l.errorBar,
      };

  IconData get icon => switch (this) {
        ChartType.column => Icons.bar_chart,
        ChartType.bar => Icons.align_horizontal_left,
        ChartType.rangeArea => Icons.area_chart,
        ChartType.stackedColumn => Icons.stacked_bar_chart,
        ChartType.stackedBar => Icons.view_column,
        ChartType.stackedColumn100 => Icons.stacked_line_chart,
        ChartType.histogram => Icons.equalizer,
        ChartType.boxAndWhisker => Icons.candlestick_chart,
        ChartType.radialBar => Icons.donut_small,
        ChartType.doughnut => Icons.donut_large,
        ChartType.pie => Icons.pie_chart,
        ChartType.errorBar => Icons.error_outline,
      };

  /// Whether this type renders in a circular chart (pie/doughnut/radial bar)
  /// rather than the cartesian chart.
  bool get isCircular =>
      this == ChartType.pie ||
      this == ChartType.doughnut ||
      this == ChartType.radialBar;
}
