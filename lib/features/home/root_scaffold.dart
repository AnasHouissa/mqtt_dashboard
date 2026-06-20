import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../dashboards/dashboard_list_screen.dart';
import '../datasource/data_source_screen.dart';
import '../settings/settings_screen.dart';

/// App root: a [BottomNavigationBar] over an [IndexedStack] of the three
/// top-level destinations (Data source, Dashboard, Settings). IndexedStack
/// keeps each destination's state alive while switching tabs.
class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _index = 0;

  static const _pages = [
    DataSourceScreen(),
    DashboardListScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dns_outlined),
            activeIcon: const Icon(Icons.dns),
            label: l.dataSource,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: l.dashboards,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l.settings,
          ),
        ],
      ),
    );
  }
}
