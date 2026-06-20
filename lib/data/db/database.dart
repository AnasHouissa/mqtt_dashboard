import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Chart visualization style. New values are appended (never reordered) so the
/// integer indexes already persisted in the database stay valid.
enum ChartType { line, histogram, spline, area, scatter }

/// Time bucket used to aggregate readings for histograms / filtering.
enum TimeBucket { today, day, month, year }

@DataClassName('Broker')
class Brokers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get address => text()();
  IntColumn get port => integer()();
  TextColumn get username => text().nullable()();
  TextColumn get password => text().nullable()();

  /// Connect over TLS (defaults the port to 8883 in the UI).
  BoolColumn get secure => boolean().withDefault(const Constant(false))();

  /// MQTT keep-alive ping interval, in seconds.
  IntColumn get keepAlive => integer().withDefault(const Constant(30))();

  /// Connection handshake timeout, in seconds.
  IntColumn get connectTimeout => integer().withDefault(const Constant(10))();

  /// Default QoS (0/1/2) applied to subscribes and publishes for this broker.
  IntColumn get qos => integer().withDefault(const Constant(1))();

  /// Whether published messages set the broker's retain flag.
  BoolColumn get retain => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Metric')
class Metrics extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get brokerId =>
      integer().references(Brokers, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get topic => text()();
  BoolColumn get publishEnabled =>
      boolean().withDefault(const Constant(false))();
  RealColumn get minValue => real().nullable()();
  RealColumn get maxValue => real().nullable()();

  /// When true, charts use [minValue]/[maxValue] as fixed Y-axis bounds.
  /// When false, the axis auto-scales to the received readings.
  BoolColumn get useFixedRange =>
      boolean().withDefault(const Constant(false))();
}

/// Dashboards are global: a dashboard groups charts that may visualize metrics
/// from any data source (broker), so it deliberately has no broker foreign key.
@DataClassName('Dashboard')
class Dashboards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
}

/// A chart belongs to a dashboard and groups one or more [ChartSeries].
@DataClassName('ChartConfig')
class Charts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dashboardId =>
      integer().references(Dashboards, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().nullable()();
}

/// One plotted series within a [Charts] chart: a metric rendered with its own
/// visualization [type], [color] and [visible] flag. A chart can mix types.
@DataClassName('ChartSeriesRow')
class ChartSeries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chartId =>
      integer().references(Charts, #id, onDelete: KeyAction.cascade)();
  IntColumn get metricId =>
      integer().references(Metrics, #id, onDelete: KeyAction.cascade)();
  IntColumn get type => intEnum<ChartType>()();

  /// ARGB color value used to draw the series.
  IntColumn get color => integer()();
  BoolColumn get visible => boolean().withDefault(const Constant(true))();

  /// Display order within the chart.
  IntColumn get position => integer().withDefault(const Constant(0))();
}

@DataClassName('Reading')
class Readings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get metricId =>
      integer().references(Metrics, #id, onDelete: KeyAction.cascade)();
  RealColumn get value => real()();
  DateTimeColumn get timestamp => dateTime()();
}

/// A single aggregated point: a time bucket label and the average value in it.
class AggregatedPoint {
  final DateTime time;
  final double value;
  const AggregatedPoint(this.time, this.value);
}

@DriftDatabase(
    tables: [Brokers, Metrics, Dashboards, Charts, ChartSeries, Readings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'mqtt_dash'));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // Enforce ON DELETE CASCADE foreign keys.
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_readings_metric_time '
            'ON readings (metric_id, timestamp)',
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 charts held a single metric + type. Move each into its own
            // series (default blue color, visible), then drop the now-unused
            // columns from `charts`. `0xFF2563EB` is AppColors.primary.
            await m.createTable(chartSeries);
            await customStatement(
              'INSERT INTO chart_series '
              '(chart_id, metric_id, type, color, visible, position) '
              'SELECT id, metric_id, type, 0xFF2563EB, 1, 0 FROM charts',
            );
            await m.alterTable(TableMigration(charts));
          }
          if (from < 3) {
            // Per-broker connection config. All have non-null defaults, so
            // existing rows keep working unchanged.
            await m.addColumn(brokers, brokers.secure);
            await m.addColumn(brokers, brokers.keepAlive);
            await m.addColumn(brokers, brokers.connectTimeout);
            await m.addColumn(brokers, brokers.qos);
            await m.addColumn(brokers, brokers.retain);
          }
          if (from < 4) {
            await m.addColumn(metrics, metrics.useFixedRange);
          }
          if (from < 5) {
            // Dashboards became global: drop the broker_id column (and its FK)
            // while preserving existing dashboards (id + name copy over).
            await m.alterTable(TableMigration(dashboards));
          }
        },
      );
}
