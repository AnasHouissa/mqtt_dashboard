import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';

/// Manage the reusable SMS topic presets (e.g. `DOOR ALERT`, `TEMP ALERT`).
/// Reached from Settings; the same presets are offered as a dropdown in the SMS
/// metric form, where new ones can also be added on the fly.
class SmsTopicsScreen extends ConsumerWidget {
  const SmsTopicsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final presets = ref.watch(smsTopicPresetsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.smsTopicPresets)),
      body: presets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.label_outline,
              message: l.noSmsTopics,
              actionLabel: l.addSmsTopic,
              onAction: () => showAddSmsTopicDialog(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 96),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, i) {
              final preset = list[i];
              return ListTile(
                leading: const Icon(Icons.label_outline),
                title: Text(preset.label),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.textMuted),
                  tooltip: l.delete,
                  onPressed: () async {
                    if (await confirmDelete(
                      context,
                      message: l.deleteNamedBody(preset.label),
                    )) {
                      await ref
                          .read(smsTopicPresetRepositoryProvider)
                          .delete(preset.id);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddSmsTopicDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.addSmsTopic),
      ),
    );
  }
}

/// Prompts for a new topic label and persists it as a preset. Returns the
/// canonical label to select (the existing one when a case-insensitive match
/// already exists, so no duplicate is created), or null if cancelled/empty.
///
/// Shared by [SmsTopicsScreen] and the SMS metric form so a topic can be added
/// from either place.
Future<String?> showAddSmsTopicDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final l = AppLocalizations.of(context);
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final label = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l.addSmsTopic),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(labelText: l.smsTopicLabel),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
          onFieldSubmitted: (_) {
            if (formKey.currentState!.validate()) {
              Navigator.pop(dialogContext, controller.text.trim());
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(dialogContext, controller.text.trim());
            }
          },
          child: Text(l.save),
        ),
      ],
    ),
  );
  controller.dispose();

  if (label == null || label.isEmpty) return null;

  final repo = ref.read(smsTopicPresetRepositoryProvider);
  // Reuse an existing label that differs only by case, rather than creating a
  // near-duplicate preset.
  final existing = await repo.getAll();
  for (final p in existing) {
    if (p.label.toLowerCase() == label.toLowerCase()) return p.label;
  }
  await repo.insert(label);
  return label;
}
