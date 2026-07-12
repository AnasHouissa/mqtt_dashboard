import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/app_snackbar.dart';
import 'sms_topics_screen.dart';

/// App settings: language selection and the current app version.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final version = ref.watch(appVersionProvider);
    final keepConnected = ref.watch(backgroundServiceProvider);

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
          if (Platform.isAndroid) ...[
            const Divider(),
            ListTile(
              title: Text(
                l.background,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.sync),
              title: Text(l.bgKeepConnected),
              subtitle: Text(l.bgKeepConnectedSubtitle),
              value: keepConnected,
              onChanged: (value) async {
                // The persistent service notification needs POST_NOTIFICATIONS
                // on Android 13+. Denial is non-fatal (the service still runs),
                // so we enable regardless of the result.
                if (value) await Permission.notification.request();
                await ref
                    .read(backgroundServiceProvider.notifier)
                    .setKeepConnected(value);
              },
            ),
          ],
          const Divider(),
          ListTile(
            title: Text(
              l.data,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(l.downloadSqlBackup),
            subtitle: Text(l.downloadSqlBackupSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _downloadSqlBackup(context, ref),
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

  /// Builds the full-database `.sql` dump and opens the share sheet, showing a
  /// brief error if it fails.
  Future<void> _downloadSqlBackup(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    try {
      await ref.read(sqlExportServiceProvider).exportSqlDump();
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(context, l.exportFailed, isError: true);
      }
    }
  }
}
