import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_dash/services/alert_stats.dart';

void main() {
  // A one-day window: 2024-01-02 00:00:00 UTC .. 2024-01-03 00:00:00 UTC.
  const day = 86400;
  const start = 1704153600; // 2024-01-02T00:00:00Z
  const end = start + day;

  // Helper to build a row.
  AlertRow r(int ts, double v) => (ts: ts, value: v);

  group('AlertDurationStats.fromRows', () {
    test('no readings → empty', () {
      final s = AlertDurationStats.fromRows(
        [],
        windowStartSec: start,
        windowEndSec: end,
        nowSec: end, // window fully in the past
      );
      expect(s.total, Duration.zero);
      expect(s.episodeCount, 0);
      expect(s.openSince, isNull);
    });

    test('single closed episode', () {
      // Open at +1h, clear at +1h30m → 30 min.
      final s = AlertDurationStats.fromRows(
        [r(start + 3600, 4), r(start + 5400, 0)],
        windowStartSec: start,
        windowEndSec: end,
        nowSec: end,
      );
      expect(s.total, const Duration(minutes: 30));
      expect(s.episodeCount, 1);
      expect(s.openSince, isNull);
    });

    test('consecutive active readings do not restart the clock', () {
      // Two active samples then a clear → one episode from first active.
      final s = AlertDurationStats.fromRows(
        [r(start + 600, 4), r(start + 1200, 2), r(start + 1800, 0)],
        windowStartSec: start,
        windowEndSec: end,
        nowSec: end,
      );
      expect(s.total, const Duration(minutes: 20)); // 600 → 1800
      expect(s.episodeCount, 1);
    });

    test('episode already open at window start is clamped to windowStart', () {
      // Last reading before the window is active; cleared 10 min into the day.
      final s = AlertDurationStats.fromRows(
        [r(start - 3600, 4), r(start + 600, 0)],
        windowStartSec: start,
        windowEndSec: end,
        nowSec: end,
      );
      expect(s.total, const Duration(minutes: 10));
      expect(s.episodeCount, 1);
      expect(s.openSince, isNull);
    });

    test('ongoing episode today → openSince set, total excludes live slice', () {
      final nowSec = start + 7200; // 2h into the day, still within window
      final s = AlertDurationStats.fromRows(
        [r(start + 3600, 4)], // opened 1h in, never cleared
        windowStartSec: start,
        windowEndSec: end,
        nowSec: nowSec,
      );
      expect(s.total, Duration.zero); // live slice added by the UI
      expect(s.episodeCount, 1);
      expect(s.openSince,
          DateTime.fromMillisecondsSinceEpoch((start + 3600) * 1000));
      expect(s.isActive, isTrue);
    });

    test('missed clear on a past day is clamped to window end', () {
      // Opened 1h in, never cleared, and the window is in the past (nowSec>=end).
      final s = AlertDurationStats.fromRows(
        [r(start + 3600, 4)],
        windowStartSec: start,
        windowEndSec: end,
        nowSec: end + day,
      );
      expect(s.total, Duration(seconds: end - (start + 3600)));
      expect(s.episodeCount, 1);
      expect(s.openSince, isNull);
    });

    test('multiple episodes accumulate', () {
      final s = AlertDurationStats.fromRows(
        [
          r(start + 3600, 4), // +1h open
          r(start + 5400, 0), // +1h30 clear  (30 min)
          r(start + 7200, 2), // +2h open
          r(start + 9000, 0), // +2h30 clear  (30 min)
        ],
        windowStartSec: start,
        windowEndSec: end,
        nowSec: end,
      );
      expect(s.total, const Duration(hours: 1));
      expect(s.episodeCount, 2);
    });

    test('falling edge after window end is clamped', () {
      // Cleared after the window closes: only the in-window slice counts.
      final s = AlertDurationStats.fromRows(
        [r(end - 600, 4), r(end + 600, 0)],
        windowStartSec: start,
        windowEndSec: end,
        nowSec: end + day,
      );
      expect(s.total, const Duration(minutes: 10)); // (end-600) → end
      expect(s.episodeCount, 1);
    });
  });
}
