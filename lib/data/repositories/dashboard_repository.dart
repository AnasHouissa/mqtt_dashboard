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

  /// Watch chart configs joined with their metric so the UI has the topic/name.
  Stream<List<ChartWithMetric>> watchCharts(int dashboardId) {
    final query = _db.select(_db.charts).join([
      innerJoin(_db.metrics, _db.metrics.id.equalsExp(_db.charts.metricId)),
    ])
      ..where(_db.charts.dashboardId.equals(dashboardId));

    return query.watch().map((rows) {
      return rows
          .map((row) => ChartWithMetric(
                chart: row.readTable(_db.charts),
                metric: row.readTable(_db.metrics),
              ))
          .toList();
    });
  }

  Future<int> insertChart(ChartsCompanion chart) =>
      _db.into(_db.charts).insert(chart);

  Future<int> deleteChart(int id) =>
      (_db.delete(_db.charts)..where((c) => c.id.equals(id))).go();
}

/// A chart config bundled with the metric it visualizes.
class ChartWithMetric {
  final ChartConfig chart;
  final Metric metric;
  const ChartWithMetric({required this.chart, required this.metric});
}
