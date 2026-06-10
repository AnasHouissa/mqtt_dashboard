import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/confirm_dialog.dart';
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
          if (list.isEmpty) return Center(child: Text(l.noDashboards));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final dashboard = list[i];
              return ListTile(
                leading: const Icon(Icons.dashboard),
                title: Text(dashboard.name),
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
                  icon: const Icon(Icons.delete_outline),
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
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.addDashboard),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l.dashboardName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l.save),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      await ref.read(dashboardRepositoryProvider).insertDashboard(
            DashboardsCompanion.insert(brokerId: broker.id, name: name),
          );
    }
  }
}
