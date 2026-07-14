import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/entity_card.dart';
import 'sms_source_detail_screen.dart';
import 'sms_source_form.dart';

/// The "SMS" tab inside the Data source destination: lists saved SMS sources
/// and adds new ones. Mirrors `BrokersTab`; the surrounding [DataSourceScreen]
/// owns the app bar, so this is an app-bar-less [Scaffold] for the per-tab FAB.
class SmsSourcesTab extends ConsumerWidget {
  const SmsSourcesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sources = ref.watch(smsSourcesProvider);

    return Scaffold(
      body: sources.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.sms_outlined,
              message: l.noSmsSources,
              actionLabel: l.addSmsSource,
              onAction: () => showSmsSourceForm(context),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: 96),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final source = list[i];
              return EntityCard(
                icon: Icons.sms_outlined,
                title: source.name,
                subtitle: source.phoneNumber,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SmsSourceDetailScreen(source: source),
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await showSmsSourceForm(context, source: source);
                    } else if (value == 'duplicate') {
                      await ref
                          .read(smsSourceRepositoryProvider)
                          .duplicate(source.id, l.copyOf(source.name));
                    } else if (value == 'delete') {
                      if (await confirmDelete(
                        context,
                        message: l.deleteSmsSourceBody(source.name),
                      )) {
                        await ref
                            .read(smsSourceRepositoryProvider)
                            .delete(source.id);
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text(l.editSmsSource)),
                    PopupMenuItem(value: 'duplicate', child: Text(l.duplicate)),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        l.delete,
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showSmsSourceForm(context),
        icon: const Icon(Icons.add),
        label: Text(l.addSmsSource),
      ),
    );
  }
}
