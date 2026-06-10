import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_card.dart';
import 'circle_icon.dart';

/// A tappable card row: leading circular icon, title + optional subtitle, and
/// an optional trailing widget. The card-based replacement for [ListTile].
class EntityCard extends StatelessWidget {
  const EntityCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = AppColors.primary,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Row(
        children: [
          CircleIcon(icon: icon, color: iconColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
