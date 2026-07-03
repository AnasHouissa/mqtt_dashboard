import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';

/// App-wide shell that pins a "connected" banner to the very top of every
/// screen whenever an MQTT connection is live. Wire it through
/// [MaterialApp.builder] so it sits above all routes.
///
/// The "no internet" state is intentionally NOT shown here: only the broker
/// section needs a live network (to connect/publish), so that overlay lives in
/// the broker screens. SMS, dashboards and history all work offline.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(connectionProvider) == MqttStatus.connected;
    if (!connected) return child;

    return Column(
      children: [
        const _ConnectionBanner(),
        // The banner's SafeArea already consumed the top inset, so strip it
        // from the content to avoid the app bars padding for it twice.
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _ConnectionBanner extends ConsumerWidget {
  const _ConnectionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final brokerId = ref.read(connectionProvider.notifier).activeBrokerId;
    final brokers = ref.watch(brokersProvider).valueOrNull;

    String? name;
    if (brokerId != null && brokers != null) {
      for (final b in brokers) {
        if (b.id == brokerId) {
          name = b.name;
          break;
        }
      }
    }

    return Material(
      color: AppColors.success,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi, color: Colors.white, size: 16),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  name == null ? l.connected : l.connectedTo(name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
