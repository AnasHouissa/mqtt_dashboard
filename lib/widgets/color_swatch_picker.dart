import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Curated palette used for chart series colors. Reused as the swatch set in
/// [ColorSwatchPicker] and to pick sensible defaults for new series.
const List<Color> kChartPalette = [
  Color(0xFF2563EB), // blue
  Color(0xFF16A34A), // green
  Color(0xFFEF4444), // red
  Color(0xFFF59E0B), // amber
  Color(0xFF9333EA), // purple
  Color(0xFF0891B2), // cyan
  Color(0xFFDB2777), // pink
  Color(0xFF65A30D), // lime
  Color(0xFFEA580C), // orange
  Color(0xFF4F46E5), // indigo
  Color(0xFF0D9488), // teal
  Color(0xFF64748B), // slate
];

/// A tappable grid of preset color swatches; the selected swatch shows a check.
class ColorSwatchPicker extends StatelessWidget {
  const ColorSwatchPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.palette = kChartPalette,
  });

  final Color selected;
  final ValueChanged<Color> onChanged;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final color in palette)
          _Swatch(
            color: color,
            selected: color.toARGB32() == selected.toARGB32(),
            onTap: () => onChanged(color),
          ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.textPrimary : Colors.transparent,
            width: 2,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}
