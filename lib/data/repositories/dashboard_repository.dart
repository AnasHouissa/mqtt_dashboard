import 'package:drift/drift.dart';

import '../db/database.dart';

/// CRUD + reactive reads for dashboards and their charts.
class DashboardRepository {
  DashboardRepository(this._db);

  final AppDatabase _db;

  // --- Dashboards ---

  Stream<List<Dashboard>> watchForBroker(int brokerId) =>
      (_db.select(_db.dashboards)
            ..where((d) => d.brokerId.equals(brokerId))
            ..orderBy([(d) => OrderingTerm(expression: d.name)]))
          .watch();

  Future<int> insertDashboard(DashboardsCompanion dashboard) =>
      _db.into(_db.dashboards).insert(dashboard);

  Future<int> deleteDashboard(int id) =>
      (_db.delete(_db.dashboards)..where((d) => d.id.equals(id))).go();

  // --- Charts ---

  /// Watch every chart in a dashboard with its ordered series (each joined to
  /// its metric), grouped per chart. A chart always has ≥1 series, so the inner
  /// join never hides a chart.
  Stream<List<ChartWithSeries>> watchCharts(int dashboardId) {
    final query =
        _db.select(_db.charts).join([
            innerJoin(
              _db.chartSeries,
              _db.chartSeries.chartId.equalsExp(_db.charts.id),
            ),
            innerJoin(
              _db.metrics,
              _db.metrics.id.equalsExp(_db.chartSeries.metricId),
            ),
          ])
          ..where(_db.charts.dashboardId.equals(dashboardId))
          ..orderBy([
            OrderingTerm(expression: _db.charts.id),
            OrderingTerm(expression: _db.chartSeries.position),
          ]);

    return query.watch().map((rows) {
      // Preserve chart order while grouping series under each chart.
      final byChart = <int, ChartWithSeries>{};
      for (final row in rows) {
        final chart = row.readTable(_db.charts);
        final entry = byChart.putIfAbsent(
          chart.id,
          () => ChartWithSeries(chart: chart, series: []),
        );
        entry.series.add(
          ChartSeriesWithMetric(
            series: row.readTable(_db.chartSeries),
            metric: row.readTable(_db.metrics),
          ),
        );
      }
      return byChart.values.toList();
    });
  }

  /// Create a chart and its series atomically. Each draft becomes one series,
  /// ordered by its index.
  Future<void> createChartWithSeries({
    required int dashboardId,
    String? title,
    required List<ChartSeriesDraft> series,
  }) {
    return _db.transaction(() async {
      final chartId = await _db
          .into(_db.charts)
          .insert(
            ChartsCompanion.insert(
              dashboardId: dashboardId,
              title: Value(title),
            ),
          );
      for (var i = 0; i < series.length; i++) {
        final s = series[i];
        await _db
            .into(_db.chartSeries)
            .insert(
              ChartSeriesCompanion.insert(
                chartId: chartId,
                metricId: s.metricId,
                type: s.type,
                color: s.color,
                visible: Value(s.visible),
                position: Value(i),
              ),
            );
      }
    });
  }

  /// Update an existing chart's title and replace its series atomically. The
  /// old series are deleted and recreated from [series], so adding, removing
  /// and reordering all work in one call. The chart id is preserved.
  Future<void> updateChartWithSeries({
    required int chartId,
    String? title,
    required List<ChartSeriesDraft> series,
  }) {
    return _db.transaction(() async {
      await (_db.update(_db.charts)..where((c) => c.id.equals(chartId))).write(
        ChartsCompanion(title: Value(title)),
      );
      await (_db.delete(
        _db.chartSeries,
      )..where((s) => s.chartId.equals(chartId))).go();
      for (var i = 0; i < series.length; i++) {
        final s = series[i];
        await _db
            .into(_db.chartSeries)
            .insert(
              ChartSeriesCompanion.insert(
                chartId: chartId,
                metricId: s.metricId,
                type: s.type,
                color: s.color,
                visible: Value(s.visible),
                position: Value(i),
              ),
            );
      }
    });
  }

  Future<int> deleteChart(int id) =>
      (_db.delete(_db.charts)..where((c) => c.id.equals(id))).go();
}

/// One plotted series joined to the metric it draws.
class ChartSeriesWithMetric {
  final ChartSeriesRow series;
  final Metric metric;
  const ChartSeriesWithMetric({required this.series, required this.metric});
}

/// A chart bundled with its ordered series.
class ChartWithSeries {
  final ChartConfig chart;
  final List<ChartSeriesWithMetric> series;
  const ChartWithSeries({required this.chart, required this.series});
}

/// Plain value object describing a series to create, before it has an id.
class ChartSeriesDraft {
  final int metricId;
  final ChartType type;
  final int color;
  final bool visible;
  const ChartSeriesDraft({
    required this.metricId,
    required this.type,
    required this.color,
    required this.visible,
  });
}
