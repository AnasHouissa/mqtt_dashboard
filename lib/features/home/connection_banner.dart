import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/background_service.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';
import '../brokers/connect_broker.dart';

/// App-wide shell that pins a "connected" banner to the very top of every
/// screen whenever an MQTT connection is live. Wire it through
/// [MaterialApp.builder] so it sits above all routes.
///
/// It also owns the background-mode handoff: when the app is backgrounded while
/// a broker is connected and "keep connected" is on, it hands the connection to
/// the foreground service; on resume it stops the service and reclaims the
/// connection in the UI isolate. See `background_service.dart`.
///
/// The "no internet" state is intentionally NOT shown here: only the broker
/// section needs a live network (to connect/publish), so that overlay lives in
/// the broker screens. SMS, dashboards and history all work offline.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!Platform.isAndroid) return;
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _handoffToService();
      case AppLifecycleState.resumed:
        _reclaimFromService();
        // SMS received while backgrounded is written by the plugin's own
        // isolate; cross-isolate writes don't notify this isolate's Drift
        // `.watch()` streams, so refresh the reading-derived providers.
        _refreshReadingStreams();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Backgrounding: if enabled and a broker is live, free the UI's MQTT client
  /// and let the service take over so readings keep landing.
  Future<void> _handoffToService() async {
    if (!ref.read(backgroundServiceProvider)) return;
    final connection = ref.read(connectionProvider.notifier);
    final brokerId = connection.activeBrokerId;
    if (brokerId == null ||
        ref.read(connectionProvider) != MqttStatus.connected) {
      return;
    }

    // Resolve the localized notification text now, while a BuildContext exists;
    // the service isolate has none.
    final l = AppLocalizations.of(context);
    String brokerName = '';
    try {
      brokerName =
          (await ref.read(brokerRepositoryProvider).getById(brokerId)).name;
    } catch (_) {/* broker deleted — fall back to empty name */}

    await connection.disconnect();
    await ref.read(backgroundServiceProvider.notifier).startForBroker(
          brokerId,
          notifTitle: l.bgNotificationTitle,
          notifBody: l.bgNotificationBody(brokerName),
        );
  }

  /// Foregrounding: if the service is running, stop it and reconnect in the UI
  /// isolate, then refresh the reading streams so charts show rows written while
  /// backgrounded (cross-isolate writes don't notify Drift's `.watch()`).
  Future<void> _reclaimFromService() async {
    if (!await FlutterBackgroundService().isRunning()) return;
    final brokerId =
        ref.read(sharedPreferencesProvider).getInt(kBgActiveBrokerId);
    await ref.read(backgroundServiceProvider.notifier).stop();
    if (brokerId == null) return;

    try {
      final broker = await ref.read(brokerRepositoryProvider).getById(brokerId);
      await ref.read(connectionProvider.notifier).connect(broker);
    } catch (_) {/* broker deleted — nothing to reconnect */}
  }

  /// Refresh every reading-derived provider so rows written by another isolate
  /// (the MQTT service or the SMS background handler) surface after resume.
  void _refreshReadingStreams() {
    ref.invalidate(aggregatedProvider);
    ref.invalidate(latestReadingProvider);
    ref.invalidate(alertDurationProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ConnectionBanner(),
        // The banner's SafeArea already consumed the top inset, so strip it
        // from the content to avoid the app bars padding for it twice.
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

/// Always-pinned connection status bar. Green when connected (shows the broker
/// name), amber while connecting, and amber/tappable when not connected — a tap
/// opens the connect sheet so the user can go live without leaving the screen.
class _ConnectionBanner extends ConsumerWidget {
  const _ConnectionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final status = ref.watch(connectionProvider);
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

    // Treat `failed` as "not connected" for this persistent bar; the specific
    // failure reason is surfaced via the snackbar at connect time.
    final connected = status == MqttStatus.connected;
    final connecting = status == MqttStatus.connecting;

    final (Color color, IconData icon, String label) = connected
        ? (AppColors.success, Icons.wifi, name == null ? l.connected : l.connectedTo(name))
        : connecting
            ? (AppColors.warning, Icons.wifi_find, l.connecting)
            : (AppColors.warning, Icons.wifi_off, l.notConnectedTap);

    // Only the not-connected state is actionable (opens the connect sheet).
    // This widget lives in `MaterialApp.builder`, above the Navigator, so use
    // the root navigator's own context to show the sheet.
    final onTap = (connected || connecting)
        ? null
        : () => showConnectBrokerSheet(rootNavigatorKey.currentContext!);

    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
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
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(Icons.chevron_right, color: Colors.white, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
