import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

/// App settings. For now only the app language; more sections can be added here.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: RadioGroup<Locale?>(
        groupValue: locale,
        onChanged: (value) =>
            ref.read(localeProvider.notifier).setLocale(value),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                l.language,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const RadioListTile<Locale?>(
              title: Text('English'),
              value: Locale('en'),
            ),
            const RadioListTile<Locale?>(
              title: Text('Français'),
              value: Locale('fr'),
            ),
            const RadioListTile<Locale?>(
              title: Text('System'),
              value: null,
            ),
          ],
        ),
      ),
    );
  }
}
