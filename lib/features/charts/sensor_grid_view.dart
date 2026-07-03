import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dashboard_repository.dart';
import '../../providers/providers.dart';
import '../../services/sms_parser.dart';
import '../../theme/app_theme.dart';

/// Renders a [ChartType.sensorGrid]: a grid of sensor cells (a multiple of 4,
/// laid out 4 per row) reflecting the metric's latest message. An `INx` token
/// in the latest reading fills cell `x` with the alert color; a cleared/OK
/// message greys all cells with the empty color; before any message arrives a
/// cell stays empty (outline only).
class SensorGridView extends ConsumerWidget {
  const SensorGridView({super.key, required this.item});

  final ChartSeriesWithMetric item;

  static const _cellsPerRow = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = item.series;
    final count = config.sensorCount ?? _cellsPerRow;
    final fill = Color(config.fillColor ?? AppColors.danger.toARGB32());
    final empty = Color(config.emptyColor ?? 0xFFCBD2DC);

    final reading = ref.watch(latestReadingProvider(item.metric.id));

    return reading.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (latest) {
        final received = latest != null;
        final active = received
            ? SmsParser.activeInputs(latest.raw ?? '')
            : const <int>{};

        return LayoutBuilder(
          builder: (context, constraints) {
            const spacing = AppSpacing.sm;
            final cellSize =
                (constraints.maxWidth - spacing * (_cellsPerRow - 1)) /
                    _cellsPerRow;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (var i = 1; i <= count; i++)
                  _SensorCell(
                    index: i,
                    size: cellSize.clamp(28.0, 96.0),
                    // No message yet -> empty outline. Active -> alert fill.
                    // Otherwise cleared/OK -> the empty (default) color.
                    color: !received
                        ? null
                        : (active.contains(i) ? fill : empty),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SensorCell extends StatelessWidget {
  const _SensorCell({
    required this.index,
    required this.size,
    required this.color,
  });

  final int index;

  /// The fill color, or null when nothing has been received for this cell yet
  /// (rendered as an empty dashed-looking outline).
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final filled = color != null;
    // Choose a readable label color against the cell background.
    final labelColor = filled
        ? (ThemeData.estimateBrightnessForColor(color!) == Brightness.dark
            ? Colors.white
            : AppColors.textPrimary)
        : AppColors.textMuted;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(
          color: filled ? Colors.transparent : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: Text(
        'IN$index',
        style: TextStyle(
          color: labelColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
