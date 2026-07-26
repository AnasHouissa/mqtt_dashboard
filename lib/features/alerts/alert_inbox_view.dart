import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/export_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_chip.dart';
import '../charts/date_time_range_sheet.dart';
import 'alert_level_ui.dart';

/// The "Received" tab: every alert that has fired, split into outstanding
/// (`New`) and already-triaged (`Acknowledged`). Tapping an outstanding alert
/// acknowledges it, moving it to the other tab.
///
/// The trailing action next to the tabs is per-tab: "acknowledge all" while
/// triaging new alerts, and an export / delete overflow on the acknowledged
/// list (which is the archive, so it is what you export or prune). Hence a
/// real [TabController] instead of [DefaultTabController] — the action row
/// lives outside the [TabBarView] and has to rebuild when the tab changes.
class AlertInboxView extends ConsumerStatefulWidget {
  const AlertInboxView({super.key});

  @override
  ConsumerState<AlertInboxView> createState() => _AlertInboxViewState();
}

class _AlertInboxViewState extends ConsumerState<AlertInboxView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this)
    ..addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pending =
        ref.watch(unacknowledgedAlertCountProvider).valueOrNull ?? 0;
    final onAcknowledgedTab = _tabs.index == 1;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                controller: _tabs,
                tabs: [
                  Tab(
                    text: pending > 0
                        ? '${l.alertTabNew} ($pending)'
                        : l.alertTabNew,
                  ),
                  Tab(text: l.alertTabAcknowledged),
                ],
              ),
            ),
            if (onAcknowledgedTab)
              const _AcknowledgedMenu()
            // Icon-only: a text button here squeezes the two tabs on a phone.
            else if (pending > 0)
              IconButton(
                tooltip: l.acknowledgeAll,
                icon: const Icon(Icons.done_all, color: AppColors.primary),
                onPressed: () async {
                  await ref
                      .read(alertRepositoryProvider)
                      .acknowledgeAll(DateTime.now());
                  if (context.mounted) {
                    showAppSnackBar(context, l.alertAllAcknowledged);
                  }
                },
              ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [
              _EventList(acknowledged: false),
              _EventList(acknowledged: true),
            ],
          ),
        ),
      ],
    );
  }
}

/// Export / delete actions for the acknowledged archive. Mirrors the metric
/// list's overflow menu (`metric_list_view.dart`): the same range sheet drives
/// both exporting and interval deletes.
class _AcknowledgedMenu extends ConsumerWidget {
  const _AcknowledgedMenu();

  /// Acknowledged events inside a user-picked window, or null if cancelled.
  Future<List<AlertEvent>?> _pickRangeEvents(
      BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final range = await showDateTimeRangeSheet(
      context,
      title: l.exportRange,
      confirmLabel: l.export,
    );
    if (range == null) return null;
    return ref.read(alertRepositoryProvider).eventsInRange(
          acknowledged: true,
          start: range.start,
          end: range.end,
        );
  }

  AlertExportHeaders _headers(AppLocalizations l) => (
        date: l.csvDate,
        time: l.csvTime,
        level: l.alertLevel,
        alert: l.csvAlert,
        metric: l.csvMetric,
        value: l.value,
        threshold: l.csvThreshold,
        acknowledgedAt: l.csvAcknowledgedAt,
      );

  Map<AlertLevel, String> _levelLabels(AppLocalizations l) => {
        for (final level in AlertLevel.values) level: level.label(l),
      };

  /// Localized state names for on/off conditions, whose threshold column is a
  /// state rather than a number.
  Map<AlertComparison, String> _stateLabels(AppLocalizations l) => {
        AlertComparison.isTrue: l.stateYes,
        AlertComparison.isFalse: l.stateNo,
      };

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final events = await _pickRangeEvents(context, ref);
    if (events == null) return;
    try {
      await ref.read(exportServiceProvider).exportAlertsCsv(
            baseName: l.navAlerts,
            events: events,
            headers: _headers(l),
            levelLabels: _levelLabels(l),
            stateLabels: _stateLabels(l),
            locale: locale,
          );
    } catch (_) {
      if (context.mounted) {
        showAppSnackBar(context, l.exportFailed, isError: true);
      }
    }
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final events = await _pickRangeEvents(context, ref);
    if (events == null) return;
    try {
      await ref.read(exportServiceProvider).exportAlertsPdf(
            baseName: l.navAlerts,
            title: l.alertsExportTitle,
            events: events,
            headers: _headers(l),
            levelLabels: _levelLabels(l),
            stateLabels: _stateLabels(l),
            locale: locale,
          );
    } catch (_) {
      if (context.mounted) {
        showAppSnackBar(context, l.exportFailed, isError: true);
      }
    }
  }

  /// The range sheet doubles as the confirmation here (red confirm button),
  /// exactly as the metric list's "delete history" does.
  Future<void> _deleteRange(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final range = await showDateTimeRangeSheet(
      context,
      title: l.deleteAlertsRange,
      confirmLabel: l.delete,
      confirmDanger: true,
    );
    if (range == null) return;
    final count = await ref.read(alertRepositoryProvider).deleteEventsInRange(
          acknowledged: true,
          start: range.start,
          end: range.end,
        );
    if (context.mounted) showAppSnackBar(context, l.alertsDeleted(count));
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    if (!await confirmDelete(context, message: l.deleteAllAlertsBody)) return;
    final count = await ref
        .read(alertRepositoryProvider)
        .deleteEventsInRange(acknowledged: true);
    if (context.mounted) showAppSnackBar(context, l.alertsDeleted(count));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
      onSelected: (value) async {
        switch (value) {
          case 'csv':
            await _exportCsv(context, ref);
          case 'pdf':
            await _exportPdf(context, ref);
          case 'deleteRange':
            await _deleteRange(context, ref);
          case 'deleteAll':
            await _deleteAll(context, ref);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'csv', child: Text(l.exportCsv)),
        PopupMenuItem(value: 'pdf', child: Text(l.exportPdf)),
        PopupMenuItem(value: 'deleteRange', child: Text(l.deleteAlertsRange)),
        PopupMenuItem(
          value: 'deleteAll',
          child: Text(l.deleteAllAlerts,
              style: const TextStyle(color: AppColors.danger)),
        ),
      ],
    );
  }
}

class _EventList extends ConsumerWidget {
  const _EventList({required this.acknowledged});

  final bool acknowledged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final events = ref.watch(alertEventsProvider(acknowledged));

    return events.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) {
        if (list.isEmpty) {
          return EmptyState(
            icon: acknowledged
                ? Icons.done_all
                : Icons.notifications_none_outlined,
            message: acknowledged
                ? l.noAlertsAcknowledged
                : l.noAlertsReceived,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 96),
          itemCount: list.length,
          itemBuilder: (context, i) => _AlertCard(event: list[i]),
        );
      },
    );
  }
}

/// One fired alert, laid out like the SMS raw-log rows: a severity chip and
/// timestamp on top, the rule name, then the value that tripped it.
class _AlertCard extends ConsumerWidget {
  const _AlertCard({required this.event});

  final AlertEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final acknowledged = event.acknowledgedAt != null;
    final time = DateFormat('MMM d · HH:mm:ss').format(event.triggeredAt);

    final body = eventReadout(event, locale, l);

    Future<void> ack() async {
      await ref
          .read(alertRepositoryProvider)
          .acknowledge(event.id, DateTime.now());
      if (context.mounted) showAppSnackBar(context, l.alertAcknowledged);
    }

    final card = AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: acknowledged ? null : ack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusChip(
                color: event.level.color,
                label: event.level.label(l),
              ),
              const Spacer(),
              if (acknowledged)
                const Icon(Icons.check_circle,
                    size: 16, color: AppColors.success),
              if (acknowledged) const SizedBox(width: AppSpacing.xs),
              Text(
                time,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            event.ruleName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            body,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary),
          ),
          if (!acknowledged) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: ack,
                icon: const Icon(Icons.check, size: 18),
                label: Text(l.acknowledge),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    // Acknowledged rows stay readable but visibly settled.
    return acknowledged ? Opacity(opacity: 0.6, child: card) : card;
  }
}
