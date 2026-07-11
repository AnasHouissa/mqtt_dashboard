import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/alert_stats.dart';
import '../../theme/app_theme.dart';

/// Renders a [ChartType.alertDuration]: how long a metric has been in alert
/// (value > 0) over the selected period — total time, number of episodes, and,
/// while an episode is still open, a live "open since" timer that ticks every
/// second. Background is [bgColor]; text + border use [fgColor].
class AlertDurationView extends ConsumerStatefulWidget {
  const AlertDurationView({
    super.key,
    required this.item,
    required this.bucket,
    required this.anchor,
  });

  final ChartSeriesWithMetric item;
  final TimeBucket bucket;
  final DateTime anchor;

  @override
  ConsumerState<AlertDurationView> createState() => _AlertDurationViewState();
}

class _AlertDurationViewState extends ConsumerState<AlertDurationView> {
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Keep a 1s ticker alive only while an episode is currently open, so the
  /// live elapsed display advances; cancel it otherwise.
  void _syncTicker(bool active) {
    if (active && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!active && _ticker != null) {
      _ticker!.cancel();
      _ticker = null;
    }
  }

  static String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    String two(int n) => n.toString().padLeft(2, '0');
    if (h > 0) return '$h:${two(m)}:${two(s)}';
    return '${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final config = widget.item.series;
    final bg = Color(config.bgColor ?? AppColors.primarySoft.toARGB32());
    final fg = Color(config.fgColor ?? AppColors.primary.toARGB32());

    final key = (
      metricId: widget.item.metric.id,
      bucket: widget.bucket,
      anchor: widget.anchor,
      startMinutes: null,
      endMinutes: null,
    );
    final async = ref.watch(alertDurationProvider(key));
    final stats = async.valueOrNull ?? AlertDurationStats.empty;

    _syncTicker(stats.isActive);

    // Total displayed = completed time + the live slice of any open episode.
    var total = stats.total;
    if (stats.openSince != null) {
      total += DateTime.now().difference(stats.openSince!);
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: fg, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                stats.isActive ? Icons.timelapse : Icons.timer_outlined,
                color: fg,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l.totalAlertTime,
                style: TextStyle(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            child: Text(
              _formatDuration(total),
              style: TextStyle(
                color: fg,
                fontSize: 40,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            stats.episodeCount == 0 ? l.noAlerts : l.alertCount(stats.episodeCount),
            style: TextStyle(color: fg, fontSize: 13),
          ),
          if (stats.openSince != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.openSince(
                MaterialLocalizations.of(context)
                    .formatTimeOfDay(TimeOfDay.fromDateTime(stats.openSince!)),
              ),
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
