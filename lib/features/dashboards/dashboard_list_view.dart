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
              onAction: () => showAddDashboardForm(context, ref, broker.id),
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
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.danger,
                  ),
                  onPressed: () async {
                    if (await confirmDelete(
                      context,
                      message: l.deleteNamedBody(dashboard.name),
                    )) {
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
    );
  }
}

/// Presents the "new dashboard" sheet and persists the result. Top-level so it
/// can be triggered from the list's empty state or the broker home app bar.
Future<void> showAddDashboardForm(
  BuildContext context,
  WidgetRef ref,
  int brokerId,
) async {
  final l = AppLocalizations.of(context);
  final controller = TextEditingController();
  final name = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                0,
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Row(
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
          ),
        ],
      ),
    ),
  );

  if (name != null && name.isNotEmpty) {
    await ref
        .read(dashboardRepositoryProvider)
        .insertDashboard(
          DashboardsCompanion.insert(brokerId: brokerId, name: name),
        );
  }
}
