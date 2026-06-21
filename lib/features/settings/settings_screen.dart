import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import 'sms_topics_screen.dart';

/// App settings: language selection and the current app version.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final version = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              l.language,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioGroup<Locale?>(
            groupValue: locale,
            onChanged: (value) =>
                ref.read(localeProvider.notifier).setLocale(value),
            child: Column(
              children: [
                const RadioListTile<Locale?>(
                  title: Text('English'),
                  value: Locale('en'),
                ),
                const RadioListTile<Locale?>(
                  title: Text('Français'),
                  value: Locale('fr'),
                ),
                RadioListTile<Locale?>(
                  title: Text(l.systemDefault),
                  value: null,
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              l.smsSettings,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: Text(l.smsTopicPresets),
            subtitle: Text(l.smsTopicPresetsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SmsTopicsScreen()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.appVersion),
            subtitle: Text(version.valueOrNull ?? '—'),
          ),
        ],
      ),
    );
  }
}
