import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/entity_card.dart';
import '../../widgets/labeled_add_button.dart';
import 'sms_log_view.dart';
import 'sms_metric_form.dart';

/// Home for a single SMS source: a permission banner, the source's metrics, and
/// the raw SMS log. The SMS analogue of the broker home screen (no connect step
/// — ingestion just listens).
class SmsSourceDetailScreen extends ConsumerWidget {
  const SmsSourceDetailScreen({super.key, required this.source});

  final SmsSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            source.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            LabeledAddButton(
              icon: Icons.sensors,
              label: l.addMetric,
              onPressed: () =>
                  showSmsMetricForm(context, smsSourceId: source.id),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l.metrics, icon: const Icon(Icons.sensors_outlined)),
              Tab(text: l.smsRawLog, icon: const Icon(Icons.inbox_outlined)),
            ],
          ),
        ),
        body: Column(
          children: [
            const _SmsPermissionBanner(),
            Expanded(
              child: TabBarView(
                children: [
                  _SmsMetricList(source: source),
                  SmsLogView(smsSourceId: source.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when SMS access isn't granted (Android) or isn't possible (iOS).
class _SmsPermissionBanner extends ConsumerWidget {
  const _SmsPermissionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final controller = ref.read(smsPermissionProvider.notifier);
    final granted = ref.watch(smsPermissionProvider);

    if (!controller.isSupported) {
      return _Banner(
        color: AppColors.warning,
        icon: Icons.phone_iphone,
        message: l.smsAndroidOnly,
      );
    }
    if (granted) return const SizedBox.shrink();

    return _Banner(
      color: AppColors.primary,
      icon: Icons.sms_outlined,
      message: l.smsPermissionRationale,
      action: TextButton(
        onPressed: () async {
          final ok = await controller.request();
          if (!ok && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.smsPermissionDenied)),
            );
          }
        },
        child: Text(l.grantPermission),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.color,
    required this.icon,
    required this.message,
    this.action,
  });

  final Color color;
  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color.withValues(alpha: 0.10),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

/// The metrics belonging to an SMS source, with add/edit/delete.
class _SmsMetricList extends ConsumerWidget {
  const _SmsMetricList({required this.source});

  final SmsSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final metrics = ref.watch(smsMetricsProvider(source.id));

    return metrics.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) {
        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.sensors_outlined,
            message: l.noMetrics,
            actionLabel: l.addMetric,
            onAction: () => showSmsMetricForm(context, smsSourceId: source.id),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: 96),
          itemCount: list.length,
          itemBuilder: (context, i) {
            final metric = list[i];
            return EntityCard(
              icon: Icons.sensors,
              title: metric.name,
              subtitle:
                  '${metric.topic} · ${smsValueModeLabel(l, metric.smsValueMode)}',
              onTap: () => showSmsMetricForm(
                context,
                smsSourceId: source.id,
                metric: metric,
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
                onSelected: (value) async {
                  if (value == 'edit') {
                    await showSmsMetricForm(
                      context,
                      smsSourceId: source.id,
                      metric: metric,
                    );
                  } else if (value == 'delete') {
                    if (await confirmDelete(
                      context,
                      message: l.deleteNamedBody(metric.name),
                    )) {
                      await ref
                          .read(metricRepositoryProvider)
                          .delete(metric.id);
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text(l.editMetric)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      l.delete,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
