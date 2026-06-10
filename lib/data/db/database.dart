import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Chart visualization style.
enum ChartType { line, histogram }

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
}

@DataClassName('Dashboard')
class Dashboards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get brokerId =>
      integer().references(Brokers, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
}

@DataClassName('ChartConfig')
class Charts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dashboardId =>
      integer().references(Dashboards, #id, onDelete: KeyAction.cascade)();
  IntColumn get metricId =>
      integer().references(Metrics, #id, onDelete: KeyAction.cascade)();
  IntColumn get type => intEnum<ChartType>()();
  TextColumn get title => text().nullable()();
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

@DriftDatabase(tables: [Brokers, Metrics, Dashboards, Charts, Readings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'mqtt_dash'));

  @override
  int get schemaVersion => 1;

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
      );
}
