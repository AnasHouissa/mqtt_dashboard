import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/labeled_add_button.dart';
import '../charts/chart_card.dart';
import 'add_curve_dialog.dart';
import 'leak_grid_form.dart';
import 'stat_tile_form.dart';

/// Bottom-sheet menu offering the three dashboard component kinds, then routing
/// to the matching creation form.
Future<void> showAddComponentMenu(
  BuildContext context, {
  required int dashboardId,
}) async {
  final l = AppLocalizations.of(context);
  final choice = await showModalBottomSheet<int>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.insert_chart_outlined,
                color: AppColors.primary),
            title: Text(l.addCurve),
            onTap: () => Navigator.pop(context, 0),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view, color: AppColors.primary),
            title: Text(l.addLeakGrid),
            onTap: () => Navigator.pop(context, 1),
          ),
          ListTile(
            leading:
                const Icon(Icons.text_fields, color: AppColors.primary),
            title: Text(l.addStatTile),
            onTap: () => Navigator.pop(context, 2),
          ),
        ],
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  switch (choice) {
    case 0:
      await showAddCurveSheet(context, dashboardId: dashboardId);
    case 1:
      await showLeakGridForm(context, dashboardId: dashboardId);
    case 2:
      await showStatTileForm(context, dashboardId: dashboardId);
  }
}

class DashboardDetailScreen extends ConsumerWidget {
  const DashboardDetailScreen({super.key, required this.dashboard});

  final Dashboard dashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final charts = ref.watch(chartsProvider(dashboard.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dashboard.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          LabeledAddButton(
            icon: Icons.add_chart,
            label: l.add,
            onPressed: () =>
                showAddComponentMenu(context, dashboardId: dashboard.id),
          ),
        ],
      ),
      body: charts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.insert_chart_outlined,
              message: l.noCharts,
              actionLabel: l.add,
              onAction: () =>
                  showAddComponentMenu(context, dashboardId: dashboard.id),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            itemBuilder: (context, i) => ChartCard(item: list[i]),
          );
        },
      ),
    );
  }
}
