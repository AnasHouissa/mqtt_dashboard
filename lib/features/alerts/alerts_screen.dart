import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'alert_inbox_view.dart';
import 'alert_rules_view.dart';

/// Top-level "Alerts" destination: a tabbed shell hosting the configured alert
/// rules and the inbox of alerts they have fired.
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.navAlerts),
          bottom: TabBar(
            tabs: [
              Tab(
                text: l.alertTabRules,
                icon: const Icon(Icons.notifications_active_outlined),
              ),
              Tab(
                text: l.alertTabReceived,
                icon: const Icon(Icons.inbox_outlined),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AlertRulesView(),
            AlertInboxView(),
          ],
        ),
      ),
    );
  }
}
