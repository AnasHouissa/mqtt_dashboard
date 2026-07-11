/// Alert-duration statistics derived from a metric's readings.
///
/// A reading with `value > 0` means the metric is in an active alert state
/// (one or more inputs firing); `value == 0` is a cleared state (`[OK]`). An
/// *episode* is the interval between a rising edge (0 → >0) and the next
/// falling edge (>0 → 0). This computes, for a time window, the total alert
/// time, how many episodes started, and whether one is still open right now.
///
/// Pure and side-effect free so it is fully unit-testable (mirrors
/// `SmsParser`).
library;

/// One reading row: `ts` is the unix-second timestamp, `value` the stored
/// numeric reading.
typedef AlertRow = ({int ts, double value});

/// Aggregated alert-duration figures for a single metric over one time window.
class AlertDurationStats {
  const AlertDurationStats({
    required this.total,
    required this.episodeCount,
    this.openSince,
  });

  /// Completed alert time within the window. When an episode is still open and
  /// the window includes the present ([openSince] is set), the ongoing slice is
  /// *not* counted here — the UI adds it live from [openSince].
  final Duration total;

  /// Number of alert episodes overlapping the window (each rising edge, plus an
  /// episode already open when the window began).
  final int episodeCount;

  /// Start of an episode that is still open at "now" (only set when the window
  /// includes the present, i.e. the current day). Null otherwise — a past-day
  /// episode that never cleared is clamped into [total] instead.
  final DateTime? openSince;

  bool get isActive => openSince != null;

  static const empty =
      AlertDurationStats(total: Duration.zero, episodeCount: 0);

  /// Reconstructs episodes from [rows] and folds them into stats for the window
  /// `[windowStartSec, windowEndSec)`.
  ///
  /// [rows] must be ordered by `ts` ascending and should contain the single
  /// last reading *before* [windowStartSec] (so we know if the metric was
  /// already in alert when the window opened) plus every reading inside the
  /// window. [nowSec] is the current unix second, used to decide whether a
  /// still-open episode is live (window includes the present) or a past-day
  /// episode that must be clamped to the window end.
  static AlertDurationStats fromRows(
    List<AlertRow> rows, {
    required int windowStartSec,
    required int windowEndSec,
    required int nowSec,
  }) {
    var totalSecs = 0;
    var episodeCount = 0;
    int? openStart; // start of the currently-open episode, in unix seconds

    for (final row in rows) {
      final active = row.value > 0;
      if (active) {
        if (openStart == null) {
          // Rising edge (or an episode already open before the window). Clamp
          // the start to the window; a carried-over episode starts counting at
          // windowStart. Every distinct open counts as one episode.
          openStart = row.ts >= windowStartSec ? row.ts : windowStartSec;
          episodeCount++;
        }
        // Consecutive active readings don't restart the clock.
      } else {
        if (openStart != null) {
          // Falling edge: close the episode. Clamp the end into the window.
          final end = row.ts > windowEndSec ? windowEndSec : row.ts;
          if (end > openStart) totalSecs += end - openStart;
          openStart = null;
        }
      }
    }

    if (openStart != null) {
      // Still open at the last reading. If the window includes the present,
      // expose it as live so the UI can tick the elapsed time; otherwise it is
      // a past-day episode that never cleared — clamp it to the window end.
      if (nowSec < windowEndSec) {
        return AlertDurationStats(
          total: Duration(seconds: totalSecs),
          episodeCount: episodeCount,
          openSince: DateTime.fromMillisecondsSinceEpoch(openStart * 1000),
        );
      }
      totalSecs += windowEndSec - openStart;
    }

    return AlertDurationStats(
      total: Duration(seconds: totalSecs),
      episodeCount: episodeCount,
    );
  }
}
