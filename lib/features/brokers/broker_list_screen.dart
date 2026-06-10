import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/entity_card.dart';
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
            return EmptyState(
              icon: Icons.dns_outlined,
              message: l.noBrokers,
              actionLabel: l.addBroker,
              onAction: () => showBrokerForm(context),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: 96),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final broker = list[i];
              return EntityCard(
                icon: Icons.dns_outlined,
                title: broker.name,
                subtitle: '${broker.address}:${broker.port}',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BrokerHomeScreen(broker: broker),
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
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
