import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/circle_icon.dart';
import '../../widgets/confirm_dialog.dart';
import '../dashboards/add_curve_dialog.dart';
import 'chart_fullscreen.dart';
import 'chart_type_ui.dart';
import 'chart_view.dart';
import 'time_filter.dart';

/// A dashboard chart with its own time filter, fullscreen + export + edit/delete.
class ChartCard extends ConsumerStatefulWidget {
  const ChartCard({super.key, required this.item});

  final ChartWithSeries item;

  @override
  ConsumerState<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends ConsumerState<ChartCard> {
  TimeBucket _bucket = TimeBucket.day;
  DateTime _anchor = defaultAnchor(TimeBucket.day);

  bool get _isDefault => _anchor == defaultAnchor(_bucket);

  void _selectBucket(TimeBucket b) => setState(() {
    _bucket = b;
    _anchor = defaultAnchor(b); // start each tab at its current period
  });

  Future<void> _pickPeriod() async {
    final picked = await pickPeriod(context, _bucket, _anchor);
    if (picked != null) setState(() => _anchor = picked);
  }

  ChartConfig get _chart => widget.item.chart;
  List<ChartSeriesWithMetric> get _series => widget.item.series;

  String get _title {
    if (_chart.title?.isNotEmpty == true) return _chart.title!;
    return _series.map((s) => s.metric.name).join(', ');
  }

  Future<void> _exportCsv(Metric metric) async {
    final l = AppLocalizations.of(context);
    final readings = await ref
        .read(readingRepositoryProvider)
        .rawForMetric(metric.id);
    await ref
        .read(exportServiceProvider)
        .exportCsv(
          metricName: metric.name,
          readings: readings,
          timestampHeader: l.timestamp,
          valueHeader: l.value,
        );
  }

  Future<void> _exportPdf(Metric metric) async {
    final l = AppLocalizations.of(context);
    final readings = await ref
        .read(readingRepositoryProvider)
        .rawForMetric(metric.id);
    await ref
        .read(exportServiceProvider)
        .exportPdf(
          metricName: metric.name,
          title: l.exportTitle(metric.name),
          readings: readings,
          timestampHeader: l.timestamp,
          valueHeader: l.value,
        );
  }

  /// With one series, export it directly; with several, ask which metric.
  Future<Metric?> _resolveMetric() async {
    if (_series.length == 1) return _series.first.metric;
    return showModalBottomSheet<Metric>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in _series)
              ListTile(
                leading: CircleIcon(
                  icon: s.series.type.icon,
                  color: Color(s.series.color),
                  size: 36,
                ),
                title: Text(s.metric.name),
                onTap: () => Navigator.pop(context, s.metric),
              ),
          ],
        ),
      ),
    );
  }

  void _openFullscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChartFullscreenScreen(
          series: _series,
          initialBucket: _bucket,
          initialAnchor: _anchor,
          title: _title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleIcon(icon: _series.first.series.type.icon, size: 38),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  _title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                tooltip: l.fullscreen,
                icon: const Icon(Icons.fullscreen),
                onPressed: _openFullscreen,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
                onSelected: (value) async {
                  switch (value) {
                    case 'edit':
                      await showAddCurveSheet(
                        context,
                        dashboardId: _chart.dashboardId,
                        existing: widget.item,
                      );
                    case 'csv':
                      final m = await _resolveMetric();
                      if (m != null) await _exportCsv(m);
                    case 'pdf':
                      final m = await _resolveMetric();
                      if (m != null) await _exportPdf(m);
                    case 'delete':
                      if (await confirmDelete(
                        context,
                        message: l.deleteNamedBody(_title),
                      )) {
                        await ref
                            .read(dashboardRepositoryProvider)
                            .deleteChart(_chart.id);
                      }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text(l.editCurve)),
                  PopupMenuItem(value: 'csv', child: Text(l.exportCsv)),
                  PopupMenuItem(value: 'pdf', child: Text(l.exportPdf)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      l.delete,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: TimeFilter(
              value: _bucket,
              onChanged: _selectBucket,
              onPickPeriod: _pickPeriod,
            ),
          ),
          if (!_isDefault) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: PeriodChip(
                label: formatPeriod(context, _bucket, _anchor),
                onReset: () => setState(() => _anchor = defaultAnchor(_bucket)),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 240,
            child: MetricChart(
              series: _series,
              bucket: _bucket,
              anchor: _anchor,
            ),
          ),
        ],
      ),
    );
  }
}
