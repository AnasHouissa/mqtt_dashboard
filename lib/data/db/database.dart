import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Chart visualization style. The integer index is persisted, so values are
/// only ever appended (never reordered) to keep stored charts valid.
enum ChartType {
  column,
  bar,
  rangeArea,
  stackedColumn,
  stackedBar,
  stackedColumn100,
  histogram,
  boxAndWhisker,
  radialBar,
  doughnut,
  pie,
  errorBar,
  spline,
  line,

  /// Custom "current-state" components (single metric, latest reading only —
  /// not time-series). Rendered by dedicated widgets, not Syncfusion.
  sensorGrid,
  statTile,

  /// Custom component showing how long a metric has been in alert (value > 0)
  /// over the selected period: total time, episode count and a live timer while
  /// currently open. Derived from readings, not a Syncfusion chart.
  alertDuration,
}

/// Time bucket used to aggregate readings for histograms / filtering.
enum TimeBucket { day, month, year }

/// Which kind of data source a metric draws its readings from. Stored as an
/// int index; new values are appended (never reordered). `mqtt` must stay first
/// (index 0) — it is the migration default for pre-existing broker metrics.
enum MetricSourceKind { mqtt, sms }

/// How the bracket value of an SMS line is turned into a numeric reading:
/// - [number]: parse the first numeric token (e.g. `TEMP ALERT [21.62]` -> 21.62).
/// - [activeCount]: count active input tokens (e.g. `[IN1, IN2, IN4]` -> 3, `[OK]` -> 0).
/// - [presence]: 1 when not cleared (`OK`/none), else 0.
enum SmsValueMode { number, activeCount, presence }

/// Outcome of parsing/matching a received SMS, recorded on the raw-log row.
enum SmsParseStatus { matched, unmatched, error }

/// Severity of an alert condition. Drives the notification channel importance
/// and the color used throughout the alerts UI. Stored as an int index, so
/// values are only ever appended (never reordered).
///
/// A fourth `error` level sat between [warning] and [critical] in schema v12;
/// removing it renumbered `critical` from 3 to 2, so the v13 migration folds
/// both old indices onto the new [critical] (upgrading rather than downgrading
/// the severity of existing rows).
enum AlertLevel { info, warning, critical }

/// How an incoming reading is compared against a condition's threshold.
///
/// Analog (a temperature, a level — the threshold is meaningful):
/// - [above]: fires while `value >= threshold`.
/// - [below]: fires while `value <= threshold`.
/// - [equals]: fires while `value == threshold`.
///
/// Boolean (a door, a leak — the metric is on/off and the threshold is unused):
/// - [isTrue]: fires while the metric is active, i.e. `value != 0`.
/// - [isFalse]: fires while it is cleared, i.e. `value == 0`.
///
/// Non-zero (rather than exactly 1) is what "active" means everywhere else in
/// the app — [ChartType.alertDuration] counts `value > 0` as in-alert, the
/// sensor grid fills on the same rule, and [SmsValueMode.activeCount] reports
/// *how many* inputs are active (`[IN1, IN2, IN4]` → 3). An `== 1` test would
/// silently miss those.
///
/// Stored as an int index; `above` must stay first (index 0) — it is the
/// column default — and values are only ever appended.
enum AlertComparison { above, below, equals, isTrue, isFalse }

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

  /// Which kind of data source feeds this metric. Defaults to `mqtt` (index 0)
  /// so pre-existing broker metrics keep working after migration.
  IntColumn get sourceKind =>
      intEnum<MetricSourceKind>().withDefault(const Constant(0))();

  /// Owning broker when [sourceKind] is mqtt; null for SMS metrics.
  IntColumn get brokerId => integer()
      .nullable()
      .references(Brokers, #id, onDelete: KeyAction.cascade)();

  /// Owning SMS source when [sourceKind] is sms; null for broker metrics.
  IntColumn get smsSourceId => integer()
      .nullable()
      .references(SmsSources, #id, onDelete: KeyAction.cascade)();

  /// For MQTT this is the display name; for SMS it is the station NAME line we
  /// match against (the first line of the message body).
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// For MQTT this is the subscription topic; for SMS it is the TOPIC label we
  /// match against (the text before the trailing `[ value ]`).
  TextColumn get topic => text()();
  BoolColumn get publishEnabled =>
      boolean().withDefault(const Constant(false))();
  RealColumn get minValue => real().nullable()();
  RealColumn get maxValue => real().nullable()();

  /// When true, charts use [minValue]/[maxValue] as fixed Y-axis bounds.
  /// When false, the axis auto-scales to the received readings.
  BoolColumn get useFixedRange =>
      boolean().withDefault(const Constant(false))();

  /// How to convert an SMS bracket value to a number; null for MQTT metrics.
  IntColumn get smsValueMode => intEnum<SmsValueMode>().nullable()();
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

  /// Display order of this component within its dashboard (ascending). Lower
  /// values render higher up. Reordered by drag / move up-down in the UI.
  IntColumn get position => integer().withDefault(const Constant(0))();
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

  // --- Custom-component config (all null for time-series series) ---

  /// Number of sensor cells for a [ChartType.sensorGrid] (a multiple of 4).
  IntColumn get sensorCount => integer().nullable()();

  /// ARGB fill color used when a sensor is in alert (sensorGrid).
  IntColumn get fillColor => integer().nullable()();

  /// ARGB color used for a cleared/OK sensor cell (sensorGrid default color).
  IntColumn get emptyColor => integer().nullable()();

  /// Unit label shown next to the value in a [ChartType.statTile].
  TextColumn get unit => text().nullable()();

  /// ARGB background color of a stat tile.
  IntColumn get bgColor => integer().nullable()();

  /// ARGB foreground (text + border) color of a stat tile.
  IntColumn get fgColor => integer().nullable()();

  /// Optional reference values shown small under a [ChartType.statTile]'s value:
  /// low/high bounds and up to two setpoints (consignes). All null when unset.
  /// [statMin]/[statMax] are legacy (no longer edited); the tile now shows the
  /// day's min/max instead, gated by [showDailyMin]/[showDailyMax].
  RealColumn get statMin => real().nullable()();
  RealColumn get statMax => real().nullable()();
  RealColumn get setpointOne => real().nullable()();
  RealColumn get setpointTwo => real().nullable()();

  /// When true, the stat tile shows the day's minimum / maximum received value
  /// (computed live, like the daily average).
  BoolColumn get showDailyMin => boolean().withDefault(const Constant(false))();
  BoolColumn get showDailyMax => boolean().withDefault(const Constant(false))();
}

@DataClassName('Reading')
class Readings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get metricId =>
      integer().references(Metrics, #id, onDelete: KeyAction.cascade)();
  RealColumn get value => real()();
  DateTimeColumn get timestamp => dateTime()();

  /// The raw payload / bracket value this reading was parsed from (e.g.
  /// `IN1, IN2, IN4`, `OK`, `21.62`). Kept so state components (sensor grid)
  /// can recover *which* inputs are active, which the numeric [value] loses.
  TextColumn get raw => text().nullable()();
}

/// An SMS data source: a sender phone number whose incoming messages we capture
/// and turn into readings. The number is the *sender* (a field device texting
/// the phone running the app), validated as a Tunisian E.164 number (+216...).
@DataClassName('SmsSource')
class SmsSources extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phoneNumber => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Raw log of every SMS received from a source's number (matched or not), used
/// as a per-source debug inbox to verify parsing and tune metric name/topic.
@DataClassName('SmsMessage')
class SmsMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get smsSourceId =>
      integer().references(SmsSources, #id, onDelete: KeyAction.cascade)();

  /// Raw sender address as reported by the OS.
  TextColumn get sender => text()();

  /// Full, unmodified SMS body.
  TextColumn get body => text()();
  DateTimeColumn get receivedAt => dateTime()();

  /// Outcome of parsing/matching this message.
  IntColumn get status => intEnum<SmsParseStatus>()();

  /// How many readings this message produced (0 when unmatched).
  IntColumn get readingsCreated => integer().withDefault(const Constant(0))();
}

/// User-defined, reusable SMS topic labels (e.g. `DOOR ALERT`, `TEMP ALERT`)
/// offered as a dropdown when creating SMS metrics. Purely a UI convenience: the
/// chosen label is copied onto the metric's `topic`, so deleting a preset never
/// affects metrics already using that label.
@DataClassName('SmsTopicPreset')
class SmsTopicPresets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// No two presets may share the same label.
  @override
  List<Set<Column>> get uniqueKeys => [
        {label},
      ];
}

/// A user-defined alert on a metric: a name plus one or more severity-graded
/// [AlertConditions]. Disabling the rule ([enabled] false) stops evaluation
/// without deleting it or its history.
@DataClassName('AlertRule')
class AlertRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// The watched metric — any source kind (MQTT or SMS).
  IntColumn get metricId =>
      integer().references(Metrics, #id, onDelete: KeyAction.cascade)();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// One threshold of an [AlertRules] rule. The effective threshold is
/// `setpoint + offsetValue` (the offset is the `+10 / -20 / …` adjustment
/// entered in the form), compared using [comparison].
@DataClassName('AlertCondition')
class AlertConditions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ruleId =>
      integer().references(AlertRules, #id, onDelete: KeyAction.cascade)();

  /// Reference value ("valeur consigne").
  RealColumn get setpoint => real()();

  /// Signed adjustment added to [setpoint]. Named `offsetValue` rather than
  /// `offset` because `offset` collides with drift's query-builder API.
  RealColumn get offsetValue => real().withDefault(const Constant(0))();
  IntColumn get comparison =>
      intEnum<AlertComparison>().withDefault(const Constant(0))();
  IntColumn get level => intEnum<AlertLevel>()();

  /// Display order within the rule.
  IntColumn get position => integer().withDefault(const Constant(0))();

  /// Crossing state: true while the value is *outside* the alert zone, so the
  /// next entry into the zone fires exactly once. Persisted (not held in
  /// memory) because the foreground isolate and the background service isolate
  /// both evaluate against this same database file and must not double-fire.
  BoolColumn get armed => boolean().withDefault(const Constant(true))();
}

/// A fired alert, shown in the alerts inbox until the user acknowledges it.
/// [ruleName] and [metricName] are denormalized snapshots so past events stay
/// readable after the rule or metric is renamed.
@DataClassName('AlertEvent')
class AlertEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ruleId =>
      integer().references(AlertRules, #id, onDelete: KeyAction.cascade)();
  IntColumn get conditionId =>
      integer().references(AlertConditions, #id, onDelete: KeyAction.cascade)();
  IntColumn get metricId =>
      integer().references(Metrics, #id, onDelete: KeyAction.cascade)();
  TextColumn get ruleName => text()();
  TextColumn get metricName => text()();
  IntColumn get level => intEnum<AlertLevel>()();
  IntColumn get comparison => intEnum<AlertComparison>()();

  /// The effective threshold (`setpoint + offsetValue`) at trigger time.
  RealColumn get threshold => real()();

  /// The reading value that crossed it.
  RealColumn get value => real()();
  DateTimeColumn get triggeredAt => dateTime()();

  /// Null while unacknowledged; set to the acknowledgement time on tap.
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();
}

/// A single aggregated point: a time bucket label and the average value in it.
class AggregatedPoint {
  final DateTime time;
  final double value;
  const AggregatedPoint(this.time, this.value);
}

@DriftDatabase(tables: [
  Brokers,
  Metrics,
  Dashboards,
  Charts,
  ChartSeries,
  Readings,
  SmsSources,
  SmsMessages,
  SmsTopicPresets,
  AlertRules,
  AlertConditions,
  AlertEvents,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'mqtt_dash'));

  @override
  int get schemaVersion => 13;

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
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_sms_messages_source_time '
            'ON sms_messages (sms_source_id, received_at)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_alert_events_ack_time '
            'ON alert_events (acknowledged_at, triggered_at)',
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
          if (from < 6) {
            // SMS data source. Create its tables first so the recreated metrics
            // table can resolve its new FK to sms_sources.
            await m.createTable(smsSources);
            await m.createTable(smsMessages);
            // Make metrics polymorphic: broker_id becomes nullable and three
            // columns are added (source_kind defaults to mqtt, the sms columns
            // default to null). SQLite can't relax a NOT NULL constraint in
            // place, so the table is recreated. Foreign keys are still OFF here
            // (they're only enabled in beforeOpen, which runs after migrations),
            // so dropping the old metrics table does NOT cascade-delete the
            // existing readings / chart_series rows — their metric ids are
            // preserved by the copy.
            await m.alterTable(
              TableMigration(
                metrics,
                newColumns: [
                  metrics.sourceKind,
                  metrics.smsSourceId,
                  metrics.smsValueMode,
                ],
              ),
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_sms_messages_source_time '
              'ON sms_messages (sms_source_id, received_at)',
            );
          }
          if (from < 7) {
            // Reusable SMS topic presets shown as a dropdown in the SMS metric
            // form and managed from Settings.
            await m.createTable(smsTopicPresets);
          }
          if (from < 8) {
            // Custom "current-state" dashboard components (sensor grid + stat
            // tile). New chart-series config columns are all nullable, and the
            // readings.raw column is nullable, so existing rows are untouched.
            await m.addColumn(chartSeries, chartSeries.sensorCount);
            await m.addColumn(chartSeries, chartSeries.fillColor);
            await m.addColumn(chartSeries, chartSeries.emptyColor);
            await m.addColumn(chartSeries, chartSeries.unit);
            await m.addColumn(chartSeries, chartSeries.bgColor);
            await m.addColumn(chartSeries, chartSeries.fgColor);
            await m.addColumn(readings, readings.raw);
          }
          if (from < 9) {
            // User-orderable dashboard components. The new column defaults to 0;
            // seed each chart's position from its id so existing dashboards keep
            // their current top-to-bottom order until the user reorders them.
            await m.addColumn(charts, charts.position);
            await customStatement('UPDATE charts SET position = id');
          }
          if (from < 10) {
            // Optional stat-tile reference values (min/max + two setpoints). All
            // nullable, so existing tiles are untouched.
            await m.addColumn(chartSeries, chartSeries.statMin);
            await m.addColumn(chartSeries, chartSeries.statMax);
            await m.addColumn(chartSeries, chartSeries.setpointOne);
            await m.addColumn(chartSeries, chartSeries.setpointTwo);
          }
          if (from < 11) {
            // Stat tile: show the day's min/max received value, toggled on.
            await m.addColumn(chartSeries, chartSeries.showDailyMin);
            await m.addColumn(chartSeries, chartSeries.showDailyMax);
          }
          if (from < 12) {
            // Threshold alerts: rules, their severity conditions, and the
            // fired-event inbox. All three tables are new, so nothing existing
            // is touched.
            await m.createTable(alertRules);
            await m.createTable(alertConditions);
            await m.createTable(alertEvents);
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_alert_events_ack_time '
              'ON alert_events (acknowledged_at, triggered_at)',
            );
          }
          if (from < 13) {
            // AlertLevel dropped its `error` member, renumbering critical from
            // 3 to 2. Fold both old indices onto the new critical (2) in one
            // statement — mapping them separately would collide, and rounding
            // an old `error` *up* to critical is safer than silently
            // downgrading it to a warning.
            for (final table in ['alert_conditions', 'alert_events']) {
              await customStatement(
                'UPDATE $table SET level = 2 WHERE level IN (2, 3)',
              );
            }
          }
        },
      );
}
