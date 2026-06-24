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

/// A large, tactile "3D" connect/disconnect button whose color reflects the
/// MQTT status. Tapping it toggles the connection via [onPressed]; it is
/// disabled (and shows a spinner) while connecting.
class _ConnectionButton extends StatefulWidget {
  const _ConnectionButton({required this.status, required this.onPressed});

  final MqttStatus status;
  final Future<void> Function() onPressed;

  @override
  State<_ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<_ConnectionButton> {
  /// Visual press depth of the 3D edge, in logical pixels.
  static const double _depth = 6;

  bool _pressed = false;

  /// Darkens a color to render the shaded bottom "edge" of the 3D button.
  Color _edge(Color c) => Color.lerp(c, Colors.black, 0.28)!;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final status = widget.status;
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
    final down = _pressed && enabled;

    void setPressed(bool v) {
      if (enabled && _pressed != v) setState(() => _pressed = v);
    }

    return GestureDetector(
      onTapDown: enabled ? (_) => setPressed(true) : null,
      onTapUp: enabled ? (_) => setPressed(false) : null,
      onTapCancel: enabled ? () => setPressed(false) : null,
      onTap: enabled
          ? () async {
              setPressed(false);
              await widget.onPressed();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        // Push the face down into its shaded edge when pressed.
        transform: Matrix4.translationValues(0, down ? _depth : 0, 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: [
            // Solid offset = the 3D bottom edge; shrinks when pressed.
            BoxShadow(
              color: _edge(color),
              offset: Offset(0, down ? 1 : _depth),
              blurRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (connecting)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              else
                Icon(icon, color: Colors.white, size: 26),
              const SizedBox(width: AppSpacing.sm),
              Text(
                connected ? '$label · ${l.disconnect}' : label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
