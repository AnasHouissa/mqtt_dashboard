import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../utils/number_format.dart';

/// Renders a [ChartType.statTile]: a styled value + unit box whose background
/// is [bgColor] and whose text + border use [fgColor]. Below the value a thin
/// row shows the optional reference stats (min, max, two setpoints) and the
/// daily average — muted labels over bold values, no colored chips.
class StatTileView extends ConsumerWidget {
  const StatTileView({super.key, required this.item});

  final ChartSeriesWithMetric item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    String fmt(double v) => formatMetricValue(v, locale);
    final config = item.series;
    final bg = Color(config.bgColor ?? AppColors.primarySoft.toARGB32());
    final fg = Color(config.fgColor ?? AppColors.primary.toARGB32());
    final unit = config.unit ?? '';

    final reading = ref.watch(latestReadingProvider(item.metric.id));
    final text = reading.maybeWhen(
      data: (latest) => latest == null ? '—' : fmt(latest.value),
      orElse: () => '—',
    );

    final dailyAvg = ref
        .watch(dailyAverageProvider(item.metric.id))
        .maybeWhen(data: (v) => v, orElse: () => null);

    // Reference stats shown under the value. Only set ones appear; the daily
    // average is always shown ("—" until today's first reading arrives).
    final stats = <(String, String)>[
      if (config.statMin != null) (l.minValue, fmt(config.statMin!)),
      if (config.statMax != null) (l.maxValue, fmt(config.statMax!)),
      if (config.setpointOne != null) (l.setpointOne, fmt(config.setpointOne!)),
      if (config.setpointTwo != null) (l.setpointTwo, fmt(config.setpointTwo!)),
      (l.avgPerDay, dailyAvg == null ? '—' : fmt(dailyAvg)),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The value, centered and dominant.
          FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: fg,
                    fontSize: 46,
                    fontWeight: FontWeight.w800,
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: TextStyle(
                      color: fg.withValues(alpha: 0.6),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, thickness: 1, color: fg.withValues(alpha: 0.12)),
          const SizedBox(height: AppSpacing.md),
          // A single evenly-spaced row of small stats.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (label, value) in stats)
                Expanded(child: _Stat(label: label, value: value, color: fg)),
            ],
          ),
        ],
      ),
    );
  }
}

/// One label-over-value stat cell in the tile's footer row.
class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color.withValues(alpha: 0.55),
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
