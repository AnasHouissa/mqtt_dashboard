import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A circular icon badge sitting on a soft tint of its color — used for list
/// leadings, stat tiles and action shortcuts.
class CircleIcon extends StatelessWidget {
  const CircleIcon({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}
