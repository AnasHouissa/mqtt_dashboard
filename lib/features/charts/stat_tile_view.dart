import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dashboard_repository.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';

/// Renders a [ChartType.statTile]: a styled value + unit box whose background
/// is [bgColor] and whose text + border use [fgColor]. Phase 1 shows the
/// metric's latest reading; computed stats arrive in a later phase.
class StatTileView extends ConsumerWidget {
  const StatTileView({super.key, required this.item});

  final ChartSeriesWithMetric item;

  static String _formatValue(double v) {
    // Show integers without a trailing ".0"; otherwise up to 2 decimals.
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = item.series;
    final bg = Color(config.bgColor ?? AppColors.primarySoft.toARGB32());
    final fg = Color(config.fgColor ?? AppColors.primary.toARGB32());
    final unit = config.unit ?? '';

    final reading = ref.watch(latestReadingProvider(item.metric.id));
    final text = reading.maybeWhen(
      data: (latest) => latest == null ? '—' : _formatValue(latest.value),
      orElse: () => '—',
    );

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: fg, width: 2),
      ),
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              text,
              style: TextStyle(
                color: fg,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                unit,
                style: TextStyle(
                  color: fg,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
