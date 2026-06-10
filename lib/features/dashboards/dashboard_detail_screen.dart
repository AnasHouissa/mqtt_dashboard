import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../charts/chart_card.dart';
import 'add_curve_dialog.dart';

class DashboardDetailScreen extends ConsumerWidget {
  const DashboardDetailScreen({
    super.key,
    required this.broker,
    required this.dashboard,
  });

  final Broker broker;
  final Dashboard dashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final charts = ref.watch(chartsProvider(dashboard.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(dashboard.name),
        actions: [
          IconButton(
            onPressed: () => showAddCurveSheet(
              context,
              brokerId: broker.id,
              dashboardId: dashboard.id,
            ),
            icon: const Icon(Icons.add_chart),
            tooltip: l.addCurve,
          ),
        ],
      ),
      body: charts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) return Center(child: Text(l.noCharts));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) => ChartCard(item: list[i]),
          );
        },
      ),
    );
  }
}
