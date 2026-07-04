import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers/providers.dart';
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
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MqttDashApp(),
    ),
  );
}
