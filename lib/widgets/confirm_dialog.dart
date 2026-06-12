import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Shows a yes/no confirmation; returns true if confirmed. Pass [message] to
/// describe exactly what will be deleted (e.g. include the item name and any
/// cascade warning); otherwise a generic body is shown.
Future<bool> confirmDelete(BuildContext context, {String? message}) async {
  final l = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.deleteConfirmTitle),
      content: Text(message ?? l.deleteConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel,style: TextStyle(color: AppColors.textPrimary),),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  return result ?? false;
}
