import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

/// Renders the Syncfusion chart for a metric + bucket. Reused in the dashboard
/// card and in the fullscreen view.
class MetricChart extends ConsumerWidget {
  const MetricChart({
    super.key,
    required this.metric,
    required this.type,
    required this.bucket,
  });

  final Metric metric;
  final ChartType type;
  final TimeBucket bucket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final data = ref.watch(
      aggregatedProvider((metricId: metric.id, bucket: bucket)),
    );

    return data.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')) ,
      data: (points) {
        if (points.isEmpty) return Center(child: Text(l.noData));
        return SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            dateFormat: _axisFormat(bucket),
            intervalType: _intervalType(bucket),
          ),
          // Y-axis auto-scales to the actual min/max of the readings.
          // metric.minValue/maxValue are notification thresholds (upcoming
          // feature), not chart bounds, so they are intentionally not used here.
          primaryYAxis: const NumericAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enablePanning: true,
          ),
          series: <CartesianSeries<AggregatedPoint, DateTime>>[
            if (type == ChartType.line)
              LineSeries<AggregatedPoint, DateTime>(
                dataSource: points,
                xValueMapper: (p, _) => p.time,
                yValueMapper: (p, _) => p.value,
                name: metric.name,
                markerSettings: const MarkerSettings(isVisible: true),
              )
            else
              ColumnSeries<AggregatedPoint, DateTime>(
                dataSource: points,
                xValueMapper: (p, _) => p.time,
                yValueMapper: (p, _) => p.value,
                name: metric.name,
              ),
          ],
        );
      },
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
