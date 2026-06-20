import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';
import '../brokers/broker_list_screen.dart';

/// Top-level "Data source" destination: a tabbed shell hosting the broker list
/// and (for now) an empty SMS placeholder. Future data-source types slot in as
/// additional tabs here.
class DataSourceScreen extends StatelessWidget {
  const DataSourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.dataSource),
          bottom: TabBar(
            tabs: [
              Tab(text: l.brokers, icon: const Icon(Icons.dns_outlined)),
              Tab(text: l.sms, icon: const Icon(Icons.sms_outlined)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BrokersTab(),
            _SmsTab(),
          ],
        ),
      ),
    );
  }
}

class _SmsTab extends StatelessWidget {
  const _SmsTab();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: EmptyState(
        icon: Icons.sms_outlined,
        message: l.smsComingSoon,
      ),
    );
  }
}
