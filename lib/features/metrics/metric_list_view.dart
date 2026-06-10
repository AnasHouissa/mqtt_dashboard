import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/mqtt_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/entity_card.dart';
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
                        } else if (value == 'delete') {
                          if (await confirmDelete(context)) {
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
                        PopupMenuItem(value: 'delete', child: Text(l.delete)),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'metric_fab',
        onPressed: () => showMetricForm(context, brokerId: broker.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showPublishDialog(
      BuildContext context, WidgetRef ref, Metric metric) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    final status = ref.read(connectionProvider);
    if (status != MqttStatus.connected ||
        ref.read(connectionProvider.notifier).activeBrokerId != metric.brokerId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.disconnected)),
      );
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.published)));
    }
  }
}
