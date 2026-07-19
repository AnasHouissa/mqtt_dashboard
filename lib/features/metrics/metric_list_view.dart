import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/entity_card.dart';
import '../charts/date_time_range_sheet.dart';
import 'metric_console_screen.dart';
import 'metric_form.dart';

class MetricListView extends ConsumerWidget {
  const MetricListView({super.key, required this.broker});

  final Broker broker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final metrics = ref.watch(metricsProvider(broker.id));

    return Scaffold(
      body: metrics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.sensors_outlined,
              message: l.noMetrics,
              actionLabel: l.addMetric,
              onAction: () => showMetricForm(context, brokerId: broker.id),
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
                subtitle: metric.topic,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MetricConsoleScreen(metric: metric),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (metric.publishEnabled)
                      IconButton(
                        icon: const Icon(Icons.upload_outlined),
                        tooltip: l.publish,
                        onPressed: () => _showPublishDialog(context, ref, metric),
                      ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          color: AppColors.textMuted),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await showMetricForm(context,
                              brokerId: broker.id, metric: metric);
                        } else if (value == 'duplicate') {
                          await showMetricForm(context,
                              brokerId: broker.id,
                              template: metric.copyWith(
                                  name: l.copyOf(metric.name)));
                        } else if (value == 'csv') {
                          await _exportCsv(context, ref, metric);
                        } else if (value == 'pdf') {
                          await _exportPdf(context, ref, metric);
                        } else if (value == 'deleteHistory') {
                          await _deleteHistory(context, ref, metric);
                        } else if (value == 'delete') {
                          if (await confirmDelete(context,
                              message: l.deleteNamedBody(metric.name))) {
                            await ref
                                .read(metricRepositoryProvider)
                                .delete(metric.id);
                            await ref
                                .read(connectionProvider.notifier)
                                .refreshSubscriptions();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text(l.editMetric)),
                        PopupMenuItem(
                            value: 'duplicate', child: Text(l.duplicate)),
                        PopupMenuItem(value: 'csv', child: Text(l.exportCsv)),
                        PopupMenuItem(value: 'pdf', child: Text(l.exportPdf)),
                        PopupMenuItem(
                            value: 'deleteHistory',
                            child: Text(l.deleteHistory)),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(l.delete,
                              style: const TextStyle(color: AppColors.danger)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Asks the user for a date-time range, then fetches the metric's readings
  /// within it. Returns null if the user cancelled the range picker.
  Future<List<Reading>?> _pickRangeReadings(
      BuildContext context, WidgetRef ref, Metric metric) async {
    final l = AppLocalizations.of(context);
    final range = await showDateTimeRangeSheet(
      context,
      title: l.exportRange,
      confirmLabel: l.export,
    );
    if (range == null) return null;
    return ref
        .read(readingRepositoryProvider)
        .rawForMetric(metric.id, start: range.start, end: range.end);
  }

  Future<void> _exportCsv(
      BuildContext context, WidgetRef ref, Metric metric) async {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final readings = await _pickRangeReadings(context, ref, metric);
    if (readings == null) return;
    await ref.read(exportServiceProvider).exportCsv(
          metricName: metric.name,
          readings: readings,
          dateHeader: l.csvDate,
          timeHeader: l.csvTime,
          valueHeader: l.value,
          locale: locale,
        );
  }

  Future<void> _exportPdf(
      BuildContext context, WidgetRef ref, Metric metric) async {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final readings = await _pickRangeReadings(context, ref, metric);
    if (readings == null) return;
    await ref.read(exportServiceProvider).exportPdf(
          metricName: metric.name,
          title: l.exportTitle(metric.name),
          readings: readings,
          timestampHeader: l.timestamp,
          valueHeader: l.value,
          locale: locale,
        );
  }

  /// Asks for a date-time range and deletes the metric's readings within it,
  /// reporting how many rows were removed.
  Future<void> _deleteHistory(
      BuildContext context, WidgetRef ref, Metric metric) async {
    final l = AppLocalizations.of(context);
    final range = await showDateTimeRangeSheet(
      context,
      title: l.deleteHistory,
      confirmLabel: l.delete,
      confirmDanger: true,
    );
    if (range == null) return;
    final count = await ref
        .read(readingRepositoryProvider)
        .deleteInRange(metric.id, start: range.start, end: range.end);
    if (context.mounted) {
      showAppSnackBar(context, l.historyDeleted(count));
    }
  }

  Future<void> _showPublishDialog(
      BuildContext context, WidgetRef ref, Metric metric) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    final status = ref.read(connectionProvider);
    if (status != MqttStatus.connected ||
        ref.read(connectionProvider.notifier).activeBrokerId != metric.brokerId) {
      showAppSnackBar(context, l.disconnected);
      return;
    }

    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${l.publish} • ${metric.topic}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: true),
          decoration: InputDecoration(labelText: l.valueToPublish),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l.publish),
          ),
        ],
      ),
    );

    if (value != null && value.isNotEmpty && context.mounted) {
      ref.read(connectionProvider.notifier).publish(metric.topic, value);
      showAppSnackBar(context, l.published);
    }
  }
}
