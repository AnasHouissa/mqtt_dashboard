import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/home/root_scaffold.dart';
import 'providers/providers.dart';
import 'services/alert_notifications.dart';
import 'services/background_service.dart';

Future<void> main() async {
  // NOTE: Syncfusion charts render a small watermark unless a (free) community
  // license is registered here. Obtain a key at syncfusion.com and uncomment:
  //
  // SyncfusionLicense.registerLicense('YOUR_COMMUNITY_LICENSE_KEY');

  WidgetsFlutterBinding.ensureInitialized();
  // Load persisted settings (e.g. the chosen language) before the app builds so
  // the saved locale is applied on the first frame.
  final prefs = await SharedPreferences.getInstance();

  // Configure the background foreground-service (Android only). It is not
  // started here — the app-lifecycle observer starts it on demand when
  // background mode is enabled and a broker is connected.
  if (Platform.isAndroid) {
    await initializeBackgroundService();
    // If background mode is off, make sure no stale foreground-service engine is
    // left running. That second Flutter engine's plugin registration hijacks
    // `another_telephony`'s process-global foreground SMS channel, which would
    // silently drop incoming SMS while the app is open.
    if (!(prefs.getBool(kBgKeepConnected) ?? false)) {
      final service = FlutterBackgroundService();
      if (await service.isRunning()) service.invoke('stop');
    }
  }

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  // Alert notifications: one channel per severity, plus the tap handler that
  // jumps to the alerts tab. Registered before the first alert can fire.
  await registerAlertChannels();
  await initAlertNotifications(
    onTapAlert: () => container.read(navIndexProvider.notifier).state =
        kAlertsNavIndex,
  );
  if (Platform.isAndroid) {
    await requestNotificationPermission();
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MqttDashApp(),
    ),
  );
}
