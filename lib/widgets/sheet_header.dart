import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A drag handle + title header for modal bottom sheets, giving every sheet a
/// consistent top.
class SheetHeader extends StatelessWidget {
  const SheetHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
