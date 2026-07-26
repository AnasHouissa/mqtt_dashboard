import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/alert_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import 'alert_level_ui.dart';
import 'alert_rule_form.dart';

/// The "Alerts" tab: every configured rule, grouped by the data source of the
/// metric it watches. Each group is an accordion, so a phone with many rules
/// across several brokers stays scannable.
class AlertRulesView extends ConsumerWidget {
  const AlertRulesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final rules = ref.watch(alertRulesProvider);
    final sourceNames = _sourceNames(ref);

    return Scaffold(
      body: rules.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_off_outlined,
              message: l.noAlertRules,
              actionLabel: l.addAlert,
              onAction: () => showAlertRuleForm(context),
            );
          }

          // Group by data source, preserving the query's rule ordering.
          final groups = <String, List<AlertRuleWithConditions>>{};
          for (final rule in list) {
            groups
                .putIfAbsent(_sourceLabel(rule.metric, sourceNames, l), () => [])
                .add(rule);
          }
          final keys = groups.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 96),
            itemCount: keys.length,
            itemBuilder: (context, i) => _SourceGroup(
              source: keys[i],
              rules: groups[keys[i]]!,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAlertRuleForm(context),
        icon: const Icon(Icons.add),
        label: Text(l.addAlert),
      ),
    );
  }

  /// broker ids and SMS source ids each mapped to their display name.
  static ({Map<int, String> brokers, Map<int, String> sms}) _sourceNames(
      WidgetRef ref) {
    return (
      brokers: {
        for (final b
            in ref.watch(brokersProvider).valueOrNull ?? const <Broker>[])
          b.id: b.name,
      },
      sms: {
        for (final s
            in ref.watch(smsSourcesProvider).valueOrNull ?? const <SmsSource>[])
          s.id: s.name,
      },
    );
  }

  static String _sourceLabel(
    Metric metric,
    ({Map<int, String> brokers, Map<int, String> sms}) names,
    AppLocalizations l,
  ) {
    final name = metric.sourceKind == MetricSourceKind.sms
        ? names.sms[metric.smsSourceId]
        : names.brokers[metric.brokerId];
    // The source may still be loading (or was just deleted); fall back to the
    // generic label rather than dropping the rule from the list.
    return name ?? l.dataSource;
  }
}

/// One accordion holding every rule whose metric belongs to [source].
class _SourceGroup extends StatelessWidget {
  const _SourceGroup({required this.source, required this.rules});

  final String source;
  final List<AlertRuleWithConditions> rules;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
          title: Text(
            source,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            l.alertRuleCount(rules.length),
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          children: [for (final rule in rules) _RuleRow(entry: rule)],
        ),
      ),
    );
  }
}

class _RuleRow extends ConsumerWidget {
  const _RuleRow({required this.entry});

  final AlertRuleWithConditions entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final repo = ref.read(alertRepositoryProvider);

    // "Tank level · ≥ 10, ≥ 20" — the trigger conditions at a glance. On/off
    // conditions read as a state name instead of a threshold.
    final thresholds = entry.conditions
        .map((c) => conditionSummary(
            c.comparison, c.setpoint + c.offsetValue, locale, l))
        .join(', ');

    return InkWell(
      onTap: () => showAlertRuleForm(context, rule: entry),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final c in entry.conditions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: AlertLevelDot(level: c.level),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.rule.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: entry.rule.enabled
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.metric.name} · $thresholds',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Switch(
              value: entry.rule.enabled,
              activeThumbColor: AppColors.primary,
              onChanged: (v) => repo.setEnabled(entry.rule.id, v),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
              onSelected: (value) async {
                if (value == 'edit') {
                  await showAlertRuleForm(context, rule: entry);
                } else if (value == 'delete') {
                  if (await confirmDelete(context,
                      message: l.deleteNamedBody(entry.rule.name))) {
                    await repo.deleteRule(entry.rule.id);
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(l.editAlert)),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(l.delete,
                      style: const TextStyle(color: AppColors.danger)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
