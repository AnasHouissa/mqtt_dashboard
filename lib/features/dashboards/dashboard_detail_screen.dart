import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/labeled_add_button.dart';
import '../charts/chart_card.dart';
import 'add_curve_dialog.dart';

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
            label: l.addCurve,
            onPressed: () =>
                showAddCurveSheet(context, dashboardId: dashboard.id),
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
              actionLabel: l.addCurve,
              onAction: () =>
                  showAddCurveSheet(context, dashboardId: dashboard.id),
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
