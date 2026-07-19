import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/circle_icon.dart';

/// Connects to [broker] and, on failure, surfaces the localized reason as an
/// error snackbar. Returns whether the connection succeeded. Shared by the
/// broker home screen and the connect bottom sheet so both behave identically.
Future<bool> connectBrokerWithFeedback(
  BuildContext context,
  WidgetRef ref,
  Broker broker,
) async {
  final l = AppLocalizations.of(context);
  final controller = ref.read(connectionProvider.notifier);
  final ok = await controller.connect(broker);
  if (context.mounted && !ok) {
    final reason = switch (controller.lastFailureReason) {
      MqttFailureReason.badCredentials => l.reasonBadCredentials,
      MqttFailureReason.brokerUnavailable => l.reasonBrokerUnavailable,
      MqttFailureReason.rejected => l.reasonRejected,
      MqttFailureReason.network => l.reasonNetwork,
      MqttFailureReason.unknown || null => l.reasonUnknown,
    };
    showAppSnackBar(context, l.unableToConnect(reason), isError: true);
  }
  return ok;
}

/// Bottom sheet listing the configured brokers, each with a Connect button, so
/// the user can go live without leaving the current screen. Dismisses itself
/// once a connection succeeds.
Future<void> showConnectBrokerSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) => const _ConnectBrokerSheet(),
  );
}

class _ConnectBrokerSheet extends ConsumerWidget {
  const _ConnectBrokerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final brokers = ref.watch(brokersProvider).valueOrNull ?? const <Broker>[];
    final connecting = ref.watch(connectionProvider) == MqttStatus.connecting;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Text(
                  l.selectBrokerToConnect,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          if (brokers.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(l.noBrokers,
                  style: const TextStyle(color: AppColors.textMuted)),
            )
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                children: [
                  for (final b in brokers)
                    ListTile(
                      leading: const CircleIcon(icon: Icons.dns, size: 36),
                      title: Text(b.name),
                      subtitle: Text('${b.address}:${b.port}'),
                      trailing: FilledButton(
                        onPressed: connecting
                            ? null
                            : () async {
                                final ok = await connectBrokerWithFeedback(
                                    context, ref, b);
                                if (ok && context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        child: Text(l.connect),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
