import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_pill.dart';
import '../dashboards/dashboard_list_view.dart';
import '../metrics/metric_list_view.dart';

/// Tabbed home for a single broker: connection control + Metrics + Dashboards.
class BrokerHomeScreen extends ConsumerWidget {
  const BrokerHomeScreen({super.key, required this.broker});

  final Broker broker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final status = ref.watch(connectionProvider);
    final controller = ref.read(connectionProvider.notifier);
    final isActive = controller.activeBrokerId == broker.id;
    final rawStatus = isActive ? status : MqttStatus.disconnected;
    // `failed` is surfaced via the snackbar, not the chip — show it as
    // disconnected so the UI only ever reflects the four live states.
    final effectiveStatus = status == MqttStatus.failed
        ? MqttStatus.disconnected
        : rawStatus;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(broker.name),
          bottom: TabBar(
            tabs: [
              Tab(text: l.metrics, icon: const Icon(Icons.sensors)),
              Tab(text: l.dashboards, icon: const Icon(Icons.dashboard)),
            ],
          ),
          actions: [
            _ConnectionChip(status: effectiveStatus),
            IconButton(
              tooltip: effectiveStatus == MqttStatus.connected
                  ? l.disconnect
                  : l.connect,
              icon: Icon(
                effectiveStatus == MqttStatus.connected
                    ? Icons.link_off
                    : Icons.link,
              ),
              onPressed: () async {
                if (effectiveStatus == MqttStatus.connected) {
                  await controller.disconnect();
                } else {
                  final ok = await controller.connect(broker);
                  if (context.mounted && !ok) {
                    final reason = switch (controller.lastFailureReason) {
                      MqttFailureReason.badCredentials =>
                        l.reasonBadCredentials,
                      MqttFailureReason.brokerUnavailable =>
                        l.reasonBrokerUnavailable,
                      MqttFailureReason.rejected => l.reasonRejected,
                      MqttFailureReason.network => l.reasonNetwork,
                      MqttFailureReason.unknown || null => l.reasonUnknown,
                    };
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: Colors.red.shade600,content: Text(l.unableToConnect(reason),style: TextStyle(color: Colors.white),)),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            MetricListView(broker: broker),
            DashboardListView(broker: broker),
          ],
        ),
      ),
    );
  }
}

class _ConnectionChip extends StatelessWidget {
  const _ConnectionChip({required this.status});

  final MqttStatus status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (Color color, String label) = switch (status) {
      MqttStatus.connected => (AppColors.success, l.connected),
      MqttStatus.connecting => (AppColors.warning, l.connecting),
      MqttStatus.failed => (AppColors.danger, l.connectionFailed),
      MqttStatus.disconnected => (AppColors.textMuted, l.disconnected),
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: StatusPill(color: color, label: label),
      ),
    );
  }
}
