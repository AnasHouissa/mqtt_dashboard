import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/db/database.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import 'chart_type_ui.dart';

/// Renders one Syncfusion chart for a set of series sharing a time [bucket].
/// Each visible series is drawn with its own type and color. Reused in the
/// dashboard card and the fullscreen view.
class MetricChart extends ConsumerWidget {
  const MetricChart({super.key, required this.series, required this.bucket});

  final List<ChartSeriesWithMetric> series;
  final TimeBucket bucket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final visible = series.where((s) => s.series.visible).toList();
    if (visible.isEmpty) return Center(child: Text(l.noData));

    // Each series resolves its own aggregated stream.
    final resolved = [
      for (final s in visible)
        (
          s,
          ref.watch(
            aggregatedProvider((metricId: s.metric.id, bucket: bucket)),
          ),
        ),
    ];

    if (resolved.any((r) => r.$2.isLoading) &&
        !resolved.any((r) => r.$2.hasValue)) {
      return const Center(child: CircularProgressIndicator());
    }
    final error = resolved.firstWhere(
      (r) => r.$2.hasError,
      orElse: () => (resolved.first.$1, const AsyncValue.loading()),
    );
    if (error.$2.hasError) return Center(child: Text('${error.$2.error}'));

    // Keep only series that actually have points to plot.
    final plottable = [
      for (final (s, data) in resolved)
        if ((data.valueOrNull ?? const []).isNotEmpty) (s, data.value!),
    ];
    if (plottable.isEmpty) return Center(child: Text(l.noData));

    // Pie / doughnut / radial-bar can't share a cartesian plot. If every
    // visible series is circular we render a circular chart; otherwise the
    // cartesian series win and any circular ones are skipped.
    final cartesianInputs =
        plottable.where((e) => !e.$1.series.type.isCircular).toList();
    if (cartesianInputs.isEmpty) {
      return _buildCircularChart(context, plottable);
    }

    final cartesian = <CartesianSeries<AggregatedPoint, DateTime>>[
      for (final (s, points) in cartesianInputs) _buildSeries(s, points),
    ];

    // Series whose metric opted into a fixed range contribute explicit Y-axis
    // bounds; we take the widest span so every fixed series fits. If none opt
    // in (or lack values), both stay null and the axis auto-scales.
    double? axisMin, axisMax;
    for (final s in visible) {
      final m = s.metric;
      if (!m.useFixedRange || m.minValue == null || m.maxValue == null) continue;
      axisMin = axisMin == null ? m.minValue : (m.minValue! < axisMin ? m.minValue : axisMin);
      axisMax = axisMax == null ? m.maxValue : (m.maxValue! > axisMax ? m.maxValue : axisMax);
    }

    // Draw the metric's min/max (when set) as dashed horizontal reference lines,
    // colored to match the series. Independent of useFixedRange — a band shows
    // whenever a bound exists. When several series share the plot we prefix the
    // metric name so the lines stay distinguishable.
    final plotBands = _referenceLines(cartesianInputs, l);

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: _axisFormat(bucket),
        intervalType: _intervalType(bucket),
        // Keep the first/last labels from being clipped at the plot edges.
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      // Fixed bounds when a series opted in via the metric's useFixedRange;
      // otherwise null minimum/maximum lets the axis auto-scale to the data.
      primaryYAxis: NumericAxis(
        minimum: axisMin,
        maximum: axisMax,
        plotBands: plotBands,
      ),
      legend: Legend(isVisible: cartesian.length > 1),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
      ),
      series: cartesian,
    );
  }

  CartesianSeries<AggregatedPoint, DateTime> _buildSeries(
    ChartSeriesWithMetric s,
    List<AggregatedPoint> points,
  ) {
    final color = Color(s.series.color);
    final name = s.metric.name;
    DateTime x(AggregatedPoint p, int _) => p.time;
    double y(AggregatedPoint p, int _) => p.value;

    return switch (s.series.type) {
      ChartType.column => ColumnSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
      ChartType.bar => BarSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
      // No high/low dimension in the aggregated data, so the band spans from
      // the baseline (0) up to the value.
      ChartType.rangeArea => RangeAreaSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          highValueMapper: y,
          lowValueMapper: (p, _) => 0,
          name: name,
          color: color.withValues(alpha: 0.4),
          borderColor: color,
          borderWidth: 2,
        ),
      ChartType.stackedColumn => StackedColumnSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
      ChartType.stackedBar => StackedBarSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
      ChartType.stackedColumn100 =>
        StackedColumn100Series<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
      // Rendered as tightly-packed columns (spacing 0) for a histogram look.
      ChartType.histogram => ColumnSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
          spacing: 0,
        ),
      // Each bucket carries a single value, so the box collapses to that value.
      ChartType.boxAndWhisker =>
        BoxAndWhiskerSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: (p, _) => <num?>[p.value],
          name: name,
          color: color,
        ),
      ChartType.errorBar => ErrorBarSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
      // Smooth curve through the points.
      ChartType.spline => SplineSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      // Straight segments between the points.
      ChartType.line => LineSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      // Circular types never reach here; they are handled by the circular chart.
      ChartType.radialBar ||
      ChartType.doughnut ||
      ChartType.pie =>
        ColumnSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
    };
  }

  /// Builds dashed Y-axis reference lines for each cartesian metric's min/max
  /// bounds (when set). `PlotBand` with `start == end` renders as a single line.
  List<PlotBand> _referenceLines(
    List<(ChartSeriesWithMetric, List<AggregatedPoint>)> cartesianInputs,
    AppLocalizations l,
  ) {
    final multi = cartesianInputs.length > 1;
    final bands = <PlotBand>[];
    for (final (s, _) in cartesianInputs) {
      final color = Color(s.series.color);
      final lineColor = color.withValues(alpha: 0.45);
      final prefix = multi ? '${s.metric.name} ' : '';
      PlotBand line(double value, String label, TextAnchor vAlign) => PlotBand(
            isVisible: true,
            start: value,
            end: value,
            borderColor: lineColor,
            borderWidth: 1,
            // Tight dash pattern reads as a dotted line.
            dashArray: const <double>[1, 3],
            text: '$prefix$label',
            textStyle: TextStyle(fontSize: 9, color: lineColor),
            horizontalTextAlignment: TextAnchor.end,
            verticalTextAlignment: vAlign,
          );
      if (s.metric.minValue != null) {
        bands.add(line(s.metric.minValue!, l.minValue, TextAnchor.end));
      }
      if (s.metric.maxValue != null) {
        bands.add(line(s.metric.maxValue!, l.maxValue, TextAnchor.start));
      }
    }
    return bands;
  }

  /// Renders pie / doughnut / radial-bar series. Each metric's time buckets
  /// become the slices/segments of its own ring; multiple circular series stack
  /// as concentric rings.
  Widget _buildCircularChart(
    BuildContext context,
    List<(ChartSeriesWithMetric, List<AggregatedPoint>)> plottable,
  ) {
    final circular = plottable.where((e) => e.$1.series.type.isCircular);
    final fmt = _axisFormat(bucket);
    String label(AggregatedPoint p, int _) => fmt.format(p.time);
    double value(AggregatedPoint p, int _) => p.value;

    final series = <CircularSeries<AggregatedPoint, String>>[
      for (final (s, points) in circular)
        switch (s.series.type) {
          ChartType.pie => PieSeries<AggregatedPoint, String>(
              dataSource: points,
              xValueMapper: label,
              yValueMapper: value,
              name: s.metric.name,
            ),
          ChartType.doughnut => DoughnutSeries<AggregatedPoint, String>(
              dataSource: points,
              xValueMapper: label,
              yValueMapper: value,
              name: s.metric.name,
            ),
          _ => RadialBarSeries<AggregatedPoint, String>(
              dataSource: points,
              xValueMapper: label,
              yValueMapper: value,
              name: s.metric.name,
              cornerStyle: CornerStyle.bothCurve,
            ),
        },
    ];

    return SfCircularChart(
      legend: const Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: series,
    );
  }

  static DateFormat _axisFormat(TimeBucket bucket) {
    switch (bucket) {
      case TimeBucket.today:
        return DateFormat.Hm(); // hour:minute
      case TimeBucket.day:
        return DateFormat.MMMd();
      case TimeBucket.month:
        return DateFormat.yMMM();
      case TimeBucket.year:
        return DateFormat.y();
    }
  }

  static DateTimeIntervalType _intervalType(TimeBucket bucket) {
    switch (bucket) {
      case TimeBucket.today:
        // Raw readings can span minutes or hours; let the axis pick the unit so
        // ticks/labels always fall inside the visible range.
        return DateTimeIntervalType.auto;
      case TimeBucket.day:
        return DateTimeIntervalType.days;
      case TimeBucket.month:
        return DateTimeIntervalType.months;
      case TimeBucket.year:
        return DateTimeIntervalType.years;
    }
  }
}
