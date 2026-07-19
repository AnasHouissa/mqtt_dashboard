import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/labeled_add_button.dart';
import '../metrics/metric_form.dart';
import '../metrics/metric_list_view.dart';

/// Home for a single broker: connection control + the broker's Metrics.
/// (Dashboards are now a global top-level destination, not nested here.)
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

    return Scaffold(
      appBar: AppBar(
        title: Text(broker.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl + AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: _ConnectionButton(
              status: effectiveStatus,
              onPressed: () async {
                if (effectiveStatus == MqttStatus.connected) {
                  await controller.disconnect();
                  return;
                }
                final ok = await controller.connect(broker);
                if (context.mounted && !ok) {
                  final reason = switch (controller.lastFailureReason) {
                    MqttFailureReason.badCredentials => l.reasonBadCredentials,
                    MqttFailureReason.brokerUnavailable =>
                      l.reasonBrokerUnavailable,
                    MqttFailureReason.rejected => l.reasonRejected,
                    MqttFailureReason.network => l.reasonNetwork,
                    MqttFailureReason.unknown || null => l.reasonUnknown,
                  };
                  showAppSnackBar(
                    context,
                    l.unableToConnect(reason),
                    isError: true,
                  );
                }
              },
            ),
          ),
        ),
        actions: [
          LabeledAddButton(
            icon: Icons.sensors,
            label: l.addMetric,
            onPressed: () => showMetricForm(context, brokerId: broker.id),
          ),
        ],
      ),
      body: MetricListView(broker: broker),
    );
  }
}

/// A flat connect/disconnect button whose color reflects the MQTT status.
/// Tapping it toggles the connection via [onPressed]; it is disabled (and shows
/// a spinner) while connecting.
class _ConnectionButton extends StatelessWidget {
  const _ConnectionButton({required this.status, required this.onPressed});

  final MqttStatus status;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final connecting = status == MqttStatus.connecting;
    final connected = status == MqttStatus.connected;

    final (Color color, IconData icon, String label) = switch (status) {
      MqttStatus.connected => (AppColors.success, Icons.wifi, l.connected),
      MqttStatus.connecting => (AppColors.warning, Icons.wifi_find, l.connecting),
      MqttStatus.failed => (AppColors.danger, Icons.wifi_off, l.connectionFailed),
      MqttStatus.disconnected =>
        (AppColors.primary, Icons.wifi_off, l.disconnected),
    };

    // While connecting we neither toggle nor animate the press.
    final enabled = !connecting;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: connecting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Icon(icon, size: 22),
        label: Text(connected ? '$label · ${l.disconnect}' : label),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: color,
          disabledForegroundColor: Colors.white,
          minimumSize: const Size(0, 52),
        ),
      ),
    );
  }
}
