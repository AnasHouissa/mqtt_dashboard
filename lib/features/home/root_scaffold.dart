import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../alerts/alerts_screen.dart';
import '../dashboards/dashboard_list_screen.dart';
import '../datasource/data_source_screen.dart';
import '../settings/settings_screen.dart';

/// Index of the Alerts destination, so a tapped alert notification can select
/// it from `main()` without reaching into this widget's state.
const kAlertsNavIndex = 2;

/// App root: a [BottomNavigationBar] over an [IndexedStack] of the four
/// top-level destinations (Data, Boards, Alerts, Settings). Each destination
/// owns a nested [Navigator], so detail screens pushed from within a tab stay
/// *above* the content but *below* the nav bar — the bar stays sticky across
/// the whole app. Screens that must cover the bar (e.g. the landscape chart
/// fullscreen) push on the root navigator with `rootNavigator: true`.
///
/// The selected index lives in [navIndexProvider] rather than local state so
/// notification taps can switch destinations from outside the widget tree.
class RootScaffold extends ConsumerStatefulWidget {
  const RootScaffold({super.key});

  @override
  ConsumerState<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends ConsumerState<RootScaffold> {
  static const _pages = [
    DataSourceScreen(),
    DashboardListScreen(),
    AlertsScreen(),
    SettingsScreen(),
  ];

  final _navKeys =
      List.generate(_pages.length, (_) => GlobalKey<NavigatorState>());

  int get _index => ref.read(navIndexProvider);
  set _index(int value) => ref.read(navIndexProvider.notifier).state = value;

  void _onTap(int i) {
    if (i == _index) {
      // Re-tapping the active tab pops it back to its root.
      _navKeys[i].currentState?.popUntil((r) => r.isFirst);
    } else {
      _index = i;
    }
  }

  void _handleBack() {
    final nav = _navKeys[_index].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    } else if (_index != 0) {
      _index = 0;
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
    final index = ref.watch(navIndexProvider);
    final pendingAlerts =
        ref.watch(unacknowledgedAlertCountProvider).valueOrNull ?? 0;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: List.generate(_pages.length, _tabNavigator),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
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
              icon: Badge.count(
                count: pendingAlerts,
                isLabelVisible: pendingAlerts > 0,
                child: const Icon(Icons.notifications_outlined),
              ),
              activeIcon: Badge.count(
                count: pendingAlerts,
                isLabelVisible: pendingAlerts > 0,
                child: const Icon(Icons.notifications),
              ),
              label: l.navAlerts,
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
