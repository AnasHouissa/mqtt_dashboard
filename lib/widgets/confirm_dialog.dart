import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Shows a yes/no confirmation; returns true if confirmed.
Future<bool> confirmDelete(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.deleteConfirmTitle),
      content: Text(l.deleteConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  return result ?? false;
}
