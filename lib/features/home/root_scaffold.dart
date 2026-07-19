import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../dashboards/dashboard_list_screen.dart';
import '../datasource/data_source_screen.dart';
import '../settings/settings_screen.dart';

/// App root: a [BottomNavigationBar] over an [IndexedStack] of the three
/// top-level destinations (Data, Boards, Settings). Each destination owns a
/// nested [Navigator], so detail screens pushed from within a tab stay *above*
/// the content but *below* the nav bar — the bar stays sticky across the whole
/// app. Screens that must cover the bar (e.g. the landscape chart fullscreen)
/// push on the root navigator with `rootNavigator: true`.
class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _index = 0;

  final _navKeys = List.generate(3, (_) => GlobalKey<NavigatorState>());

  static const _pages = [
    DataSourceScreen(),
    DashboardListScreen(),
    SettingsScreen(),
  ];

  void _onTap(int i) {
    if (i == _index) {
      // Re-tapping the active tab pops it back to its root.
      _navKeys[i].currentState?.popUntil((r) => r.isFirst);
    } else {
      setState(() => _index = i);
    }
  }

  void _handleBack() {
    final nav = _navKeys[_index].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    } else if (_index != 0) {
      setState(() => _index = 0);
    } else {
      SystemNavigator.pop();
    }
  }

  Widget _tabNavigator(int i) => Navigator(
        key: _navKeys[i],
        onGenerateRoute: (settings) =>
            MaterialPageRoute(builder: (_) => _pages[i]),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: List.generate(3, _tabNavigator),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          iconSize: 22,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dns_outlined),
              activeIcon: const Icon(Icons.dns),
              label: l.navData,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: l.navBoards,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: l.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
