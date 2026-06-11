import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/db/database.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

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

    final cartesian = <CartesianSeries<AggregatedPoint, DateTime>>[
      for (final (s, data) in resolved)
        if ((data.valueOrNull ?? const []).isNotEmpty)
          _buildSeries(s, data.value!),
    ];
    if (cartesian.isEmpty) return Center(child: Text(l.noData));

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

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: _axisFormat(bucket),
        intervalType: _intervalType(bucket),
      ),
      // Fixed bounds when a series opted in via the metric's useFixedRange;
      // otherwise null minimum/maximum lets the axis auto-scale to the data.
      primaryYAxis: NumericAxis(minimum: axisMin, maximum: axisMax),
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
    const marker = MarkerSettings(isVisible: true);

    return switch (s.series.type) {
      ChartType.line => LineSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
          markerSettings: marker,
        ),
      ChartType.spline => SplineSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
          markerSettings: marker,
        ),
      ChartType.area => AreaSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color.withValues(alpha: 0.4),
          borderColor: color,
          borderWidth: 2,
        ),
      ChartType.histogram => ColumnSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
      ChartType.scatter => ScatterSeries<AggregatedPoint, DateTime>(
          dataSource: points,
          xValueMapper: x,
          yValueMapper: y,
          name: name,
          color: color,
        ),
    };
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
        return DateTimeIntervalType.hours;
      case TimeBucket.day:
        return DateTimeIntervalType.days;
      case TimeBucket.month:
        return DateTimeIntervalType.months;
      case TimeBucket.year:
        return DateTimeIntervalType.years;
    }
  }
}
