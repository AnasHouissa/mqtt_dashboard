import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Pinned Cancel / Save bar at the bottom of a modal sheet. Save is disabled
/// when [onSave] is null.
class SheetActionBar extends StatelessWidget {
  const SheetActionBar({super.key, required this.onCancel, this.onSave});

  final VoidCallback onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(onPressed: onCancel, child: Text(l.cancel)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: FilledButton(onPressed: onSave, child: Text(l.save)),
          ),
        ],
      ),
    );
  }
}
