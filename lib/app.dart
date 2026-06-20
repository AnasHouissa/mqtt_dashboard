import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/home/connection_banner.dart';
import 'features/home/root_scaffold.dart';
import 'l10n/app_localizations.dart';
import 'providers/providers.dart';
import 'theme/app_theme.dart';

class MqttDashApp extends ConsumerWidget {
  const MqttDashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      themeMode: ThemeMode.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) =>
          AppShell(child: child ?? const SizedBox.shrink()),
      home: const RootScaffold(),
    );
  }
}

