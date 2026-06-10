import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/entity_card.dart';
import '../../widgets/sheet_header.dart';
import 'dashboard_detail_screen.dart';

class DashboardListView extends ConsumerWidget {
  const DashboardListView({super.key, required this.broker});

  final Broker broker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dashboards = ref.watch(dashboardsProvider(broker.id));

    return Scaffold(
      body: dashboards.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.dashboard_outlined,
              message: l.noDashboards,
              actionLabel: l.addDashboard,
              onAction: () => _addDashboard(context, ref),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: 96),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final dashboard = list[i];
              return EntityCard(
                icon: Icons.dashboard_outlined,
                title: dashboard.name,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashboardDetailScreen(
                      broker: broker,
                      dashboard: dashboard,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.textMuted),
                  onPressed: () async {
                    if (await confirmDelete(context)) {
                      await ref
                          .read(dashboardRepositoryProvider)
                          .deleteDashboard(dashboard.id);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'dashboard_fab',
        onPressed: () => _addDashboard(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addDashboard(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetHeader(title: l.addDashboard),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(labelText: l.dashboardName),
              onSubmitted: (v) => Navigator.pop(context, v.trim()),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l.cancel),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: () =>
                      Navigator.pop(context, controller.text.trim()),
                  child: Text(l.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (name != null && name.isNotEmpty) {
      await ref.read(dashboardRepositoryProvider).insertDashboard(
            DashboardsCompanion.insert(brokerId: broker.id, name: name),
          );
    }
  }
}
