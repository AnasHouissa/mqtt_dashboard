import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/confirm_dialog.dart';
import 'chart_fullscreen.dart';
import 'chart_view.dart';
import 'time_filter.dart';

/// A dashboard chart with its own time filter, fullscreen + export + delete.
class ChartCard extends ConsumerStatefulWidget {
  const ChartCard({super.key, required this.item});

  final ChartWithMetric item;

  @override
  ConsumerState<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends ConsumerState<ChartCard> {
  TimeBucket _bucket = TimeBucket.day;

  Metric get _metric => widget.item.metric;
  ChartConfig get _chart => widget.item.chart;

  String get _title =>
      (_chart.title?.isNotEmpty == true) ? _chart.title! : _metric.name;

  Future<void> _exportCsv() async {
    final l = AppLocalizations.of(context);
    final readings =
        await ref.read(readingRepositoryProvider).rawForMetric(_metric.id);
    await ref.read(exportServiceProvider).exportCsv(
          metricName: _metric.name,
          readings: readings,
          timestampHeader: l.timestamp,
          valueHeader: l.value,
        );
  }

  Future<void> _exportPdf() async {
    final l = AppLocalizations.of(context);
    final readings =
        await ref.read(readingRepositoryProvider).rawForMetric(_metric.id);
    await ref.read(exportServiceProvider).exportPdf(
          metricName: _metric.name,
          title: l.exportTitle(_metric.name),
          readings: readings,
          timestampHeader: l.timestamp,
          valueHeader: l.value,
        );
  }

  void _openFullscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChartFullscreenScreen(
          metric: _metric,
          type: _chart.type,
          initialBucket: _bucket,
          title: _chart.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(_chart.type == ChartType.line
                    ? Icons.show_chart
                    : Icons.bar_chart),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: l.fullscreen,
                  icon: const Icon(Icons.fullscreen),
                  onPressed: _openFullscreen,
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'csv':
                        await _exportCsv();
                      case 'pdf':
                        await _exportPdf();
                      case 'delete':
                        if (await confirmDelete(context)) {
                          await ref
                              .read(dashboardRepositoryProvider)
                              .deleteChart(_chart.id);
                        }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'csv', child: Text(l.exportCsv)),
                    PopupMenuItem(value: 'pdf', child: Text(l.exportPdf)),
                    PopupMenuItem(value: 'delete', child: Text(l.delete)),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TimeFilter(
                value: _bucket,
                onChanged: (b) => setState(() => _bucket = b),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 240,
              child: MetricChart(
                metric: _metric,
                type: _chart.type,
                bucket: _bucket,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
