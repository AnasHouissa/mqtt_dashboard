import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/confirm_dialog.dart';
import '../home/broker_home_screen.dart';
import 'broker_form.dart';

class BrokerListScreen extends ConsumerWidget {
  const BrokerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final brokers = ref.watch(brokersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.brokers),
        actions: const [_LanguageButton()],
      ),
      body: brokers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return Center(child: Text(l.noBrokers));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final broker = list[i];
              return ListTile(
                leading: const Icon(Icons.dns),
                title: Text(broker.name),
                subtitle: Text('${broker.address}:${broker.port}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BrokerHomeScreen(broker: broker),
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await showBrokerForm(context, broker: broker);
                    } else if (value == 'delete') {
                      if (await confirmDelete(context)) {
                        await ref
                            .read(brokerRepositoryProvider)
                            .delete(broker.id);
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text(l.editBroker)),
                    PopupMenuItem(value: 'delete', child: Text(l.delete)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showBrokerForm(context),
        icon: const Icon(Icons.add),
        label: Text(l.addBroker),
      ),
    );
  }
}

/// Quick FR/EN/system language switcher in the app bar.
class _LanguageButton extends ConsumerWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<Locale?>(
      icon: const Icon(Icons.language),
      onSelected: (locale) =>
          ref.read(localeProvider.notifier).setLocale(locale),
      itemBuilder: (context) => const [
        PopupMenuItem(value: Locale('en'), child: Text('English')),
        PopupMenuItem(value: Locale('fr'), child: Text('Français')),
        PopupMenuItem(value: null, child: Text('System')),
      ],
    );
  }
}
