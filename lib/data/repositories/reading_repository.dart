import 'package:drift/drift.dart';

import '../db/database.dart';

/// Stores incoming readings and aggregates them for charting/export.
class ReadingRepository {
  ReadingRepository(this._db);

  final AppDatabase _db;

  Future<int> insert(int metricId, double value, DateTime timestamp) {
    return _db
        .into(_db.readings)
        .insert(
          ReadingsCompanion.insert(
            metricId: metricId,
            value: value,
            timestamp: timestamp,
          ),
        );
  }

  /// All raw readings for a metric (newest first), used for CSV/PDF export.
  Future<List<Reading>> rawForMetric(int metricId) =>
      (_db.select(_db.readings)
            ..where((r) => r.metricId.equals(metricId))
            ..orderBy([(r) => OrderingTerm(expression: r.timestamp)]))
          .get();

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
    DateTime anchor,
  ) {
    return _watchRaw(metricId, _range(bucket, anchor));
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
