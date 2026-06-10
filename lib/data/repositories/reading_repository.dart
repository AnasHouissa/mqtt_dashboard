import 'package:drift/drift.dart';

import '../db/database.dart';

/// Stores incoming readings and aggregates them for charting/export.
class ReadingRepository {
  ReadingRepository(this._db);

  final AppDatabase _db;

  Future<int> insert(int metricId, double value, DateTime timestamp) {
    return _db.into(_db.readings).insert(
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

  /// SQLite strftime format string for a bucket.
  static String _format(TimeBucket bucket) {
    switch (bucket) {
      case TimeBucket.today:
        return '%Y-%m-%d %H'; // group by hour within the day
      case TimeBucket.day:
        return '%Y-%m-%d';
      case TimeBucket.month:
        return '%Y-%m';
      case TimeBucket.year:
        return '%Y';
    }
  }

  /// Reactive aggregation: average value per [bucket] for a metric.
  ///
  /// `timestamp` is stored as unix seconds by Drift, so we convert with
  /// `datetime(timestamp, 'unixepoch', 'localtime')` before formatting.
  Stream<List<AggregatedPoint>> watchAggregated(
    int metricId,
    TimeBucket bucket,
  ) {
    final fmt = _format(bucket);
    // "Today" additionally restricts to the current local date.
    final todayFilter = bucket == TimeBucket.today
        ? "AND date(datetime(timestamp, 'unixepoch', 'localtime')) "
            "= date('now', 'localtime') "
        : '';
    final query = _db.customSelect(
      "SELECT strftime('$fmt', datetime(timestamp, 'unixepoch', 'localtime')) "
      "AS bucket, AVG(value) AS avg_value "
      "FROM readings WHERE metric_id = ?1 "
      "$todayFilter"
      "GROUP BY bucket ORDER BY bucket",
      variables: [Variable.withInt(metricId)],
      readsFrom: {_db.readings},
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        final bucketLabel = row.read<String>('bucket');
        return AggregatedPoint(
          _parseBucket(bucketLabel, bucket),
          row.read<double>('avg_value'),
        );
      }).toList();
    });
  }

  static DateTime _parseBucket(String label, TimeBucket bucket) {
    switch (bucket) {
      case TimeBucket.today:
        return DateTime.parse('$label:00:00'); // "YYYY-MM-DD HH" -> on the hour
      case TimeBucket.day:
        return DateTime.parse(label); // YYYY-MM-DD
      case TimeBucket.month:
        return DateTime.parse('$label-01'); // YYYY-MM
      case TimeBucket.year:
        return DateTime(int.parse(label)); // YYYY
    }
  }
}
