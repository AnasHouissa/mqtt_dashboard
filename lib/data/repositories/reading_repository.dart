import 'package:drift/drift.dart';

import '../../services/alert_stats.dart';
import '../db/database.dart';

/// Stores incoming readings and aggregates them for charting/export.
class ReadingRepository {
  ReadingRepository(this._db);

  final AppDatabase _db;

  Future<int> insert(
    int metricId,
    double value,
    DateTime timestamp, {
    String? raw,
  }) {
    return _db
        .into(_db.readings)
        .insert(
          ReadingsCompanion.insert(
            metricId: metricId,
            value: value,
            timestamp: timestamp,
            raw: Value(raw),
          ),
        );
  }

  /// The most recent reading for a metric, or null if none exist yet. Reactive
  /// so state components (sensor grid / stat tile) refresh as messages arrive.
  Stream<Reading?> watchLatest(int metricId) {
    return (_db.select(_db.readings)
          ..where((r) => r.metricId.equals(metricId))
          ..orderBy([
            (r) => OrderingTerm(
              expression: r.timestamp,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Reactive average of today's readings for a metric (local calendar day), or
  /// null when there are none yet. Used by the stat tile's "average per day".
  Stream<double?> watchDailyAverage(int metricId) {
    final now = DateTime.now();
    final range = _range(TimeBucket.day, now);
    final query = _db.customSelect(
      "SELECT AVG(value) AS avg FROM readings "
      "WHERE metric_id = ?1 AND timestamp >= ?2 AND timestamp < ?3",
      variables: [
        Variable.withInt(metricId),
        Variable.withInt(range.start),
        Variable.withInt(range.end),
      ],
      readsFrom: {_db.readings},
    );
    return query.watch().map((rows) => rows.first.read<double?>('avg'));
  }

  /// All raw readings for a metric (oldest first), used for CSV/PDF export.
  /// [start]/[end] optionally bound the export window (`[start, end]`,
  /// inclusive); a null bound means "unbounded on that side".
  Future<List<Reading>> rawForMetric(
    int metricId, {
    DateTime? start,
    DateTime? end,
  }) {
    final query = _db.select(_db.readings)
      ..where((r) => r.metricId.equals(metricId))
      ..orderBy([(r) => OrderingTerm(expression: r.timestamp)]);
    if (start != null) {
      query.where((r) => r.timestamp.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      query.where((r) => r.timestamp.isSmallerOrEqualValue(end));
    }
    return query.get();
  }

  /// Deletes a metric's readings within `[start, end]` (inclusive; null bound =
  /// unbounded). Returns the number of rows removed. Charts watching the metric
  /// refresh automatically.
  Future<int> deleteInRange(
    int metricId, {
    DateTime? start,
    DateTime? end,
  }) {
    final query = _db.delete(_db.readings)
      ..where((r) => r.metricId.equals(metricId));
    if (start != null) {
      query.where((r) => r.timestamp.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      query.where((r) => r.timestamp.isSmallerOrEqualValue(end));
    }
    return query.go();
  }

  /// The `[start, end)` unix-second range covered by [bucket] anchored at
  /// [anchor]. Bounds are built from *local* calendar boundaries (Dart's
  /// `DateTime(y, m, d)` is local), so `millisecondsSinceEpoch` yields the
  /// correct absolute unix second to compare against the stored `timestamp`
  /// column. Using `d + 1` / `month + 1` lets Dart handle month lengths and
  /// DST rollover.
  static ({int start, int end}) _range(TimeBucket bucket, DateTime anchor) {
    final DateTime start, end;
    switch (bucket) {
      case TimeBucket.day:
        start = DateTime(anchor.year, anchor.month, anchor.day);
        end = DateTime(anchor.year, anchor.month, anchor.day + 1);
      case TimeBucket.month:
        start = DateTime(anchor.year, anchor.month, 1);
        end = DateTime(anchor.year, anchor.month + 1, 1);
      case TimeBucket.year:
        start = DateTime(anchor.year, 1, 1);
        end = DateTime(anchor.year + 1, 1, 1);
    }
    return (
      start: start.millisecondsSinceEpoch ~/ 1000,
      end: end.millisecondsSinceEpoch ~/ 1000,
    );
  }

  /// Reactive chart data for a metric over the period identified by [bucket] +
  /// [anchor]. Every bucket (Day / Month / Year) plots the raw readings in its
  /// window exactly as received — no averaging — so each value shows up
  /// distinctly. The buckets differ only in how wide the window is.
  ///
  /// `timestamp` is stored as unix seconds by Drift; the window is filtered on
  /// that raw column so the query stays index-friendly.
  Stream<List<AggregatedPoint>> watchAggregated(
    int metricId,
    TimeBucket bucket,
    DateTime anchor, {
    int? startMinutes,
    int? endMinutes,
  }) {
    var range = _range(bucket, anchor);
    // For a day bucket, an optional time window narrows the range to
    // [dayStart + startMinutes, dayStart + endMinutes] (end inclusive of the
    // selected minute). Month/year buckets ignore the window.
    if (bucket == TimeBucket.day &&
        (startMinutes != null || endMinutes != null)) {
      final dayStart = DateTime(anchor.year, anchor.month, anchor.day);
      int sec(int minutes) =>
          dayStart.add(Duration(minutes: minutes)).millisecondsSinceEpoch ~/
          1000;
      range = (
        start: startMinutes != null ? sec(startMinutes) : range.start,
        // +1 so a reading exactly at the end minute is included.
        end: endMinutes != null ? sec(endMinutes + 1) : range.end,
      );
    }
    return _watchRaw(metricId, range);
  }

  /// Reactive alert-duration stats for a metric over the period identified by
  /// [bucket] + [anchor]: total time in alert (value > 0), episode count and a
  /// live "open since" when an episode is still ongoing. Derived from readings.
  ///
  /// The query fetches the single last reading *before* the window (so we know
  /// if the metric was already in alert when the window opened) UNIONed with all
  /// in-window readings — both index-friendly via `idx_readings_metric_time`.
  Stream<AlertDurationStats> watchAlertDuration(
    int metricId,
    TimeBucket bucket,
    DateTime anchor,
  ) {
    final range = _range(bucket, anchor);
    final query = _db.customSelect(
      "SELECT ts, value FROM ("
      "  SELECT timestamp AS ts, value FROM readings "
      "  WHERE metric_id = ?1 AND timestamp < ?2 "
      "  ORDER BY timestamp DESC LIMIT 1"
      ") "
      "UNION ALL "
      "SELECT timestamp AS ts, value FROM readings "
      "WHERE metric_id = ?1 AND timestamp >= ?2 AND timestamp < ?3 "
      "ORDER BY ts",
      variables: [
        Variable.withInt(metricId),
        Variable.withInt(range.start),
        Variable.withInt(range.end),
      ],
      readsFrom: {_db.readings},
    );

    return query.watch().map((rows) {
      final data = rows
          .map((row) => (ts: row.read<int>('ts'), value: row.read<double>('value')))
          .toList();
      return AlertDurationStats.fromRows(
        data,
        windowStartSec: range.start,
        windowEndSec: range.end,
        nowSec: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
    });
  }

  /// Every raw reading in `[range.start, range.end)`, each as its own point at
  /// its exact timestamp (ordered oldest → newest).
  Stream<List<AggregatedPoint>> _watchRaw(
    int metricId,
    ({int start, int end}) range,
  ) {
    final query = _db.customSelect(
      "SELECT timestamp AS ts, value FROM readings "
      "WHERE metric_id = ?1 AND timestamp >= ?2 AND timestamp < ?3 "
      "ORDER BY timestamp",
      variables: [
        Variable.withInt(metricId),
        Variable.withInt(range.start),
        Variable.withInt(range.end),
      ],
      readsFrom: {_db.readings},
    );

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => AggregatedPoint(
              DateTime.fromMillisecondsSinceEpoch(row.read<int>('ts') * 1000),
              row.read<double>('value'),
            ),
          )
          .toList();
    });
  }
}
