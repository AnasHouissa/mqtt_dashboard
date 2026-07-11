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
import '../dashboards/alert_duration_form.dart';
import '../dashboards/leak_grid_form.dart';
import '../dashboards/stat_tile_form.dart';
import 'alert_duration_view.dart';
import 'chart_fullscreen.dart';
import 'chart_type_ui.dart';
import 'chart_view.dart';
import 'sensor_grid_view.dart';
import 'stat_tile_view.dart';
import 'time_filter.dart';

/// A dashboard chart with its own time filter, fullscreen + export + edit/delete.
class ChartCard extends ConsumerStatefulWidget {
  const ChartCard({
    super.key,
    required this.item,
    this.onMoveUp,
    this.onMoveDown,
  });

  final ChartWithSeries item;

  /// Swap this component with the one above it. Null when already at the top.
  final VoidCallback? onMoveUp;

  /// Swap this component with the one below it. Null when already at the bottom.
  final VoidCallback? onMoveDown;

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

  /// Custom "current-state" component (sensor grid / stat tile) rather than a
  /// time-series chart. Such a chart always has exactly one series.
  ChartType get _type => _series.first.series.type;
  bool get _isCustom => _type.isCustomComponent;

  /// The time filter applies to time-series charts and to the alert-duration
  /// component (which sums over the selected period); the other custom
  /// components (sensor grid / stat tile) only show the current live state.
  bool get _showsTimeFilter =>
      !_isCustom || _type == ChartType.alertDuration;

  String get _title {
    if (_chart.title?.isNotEmpty == true) return _chart.title!;
    return _series.map((s) => s.metric.name).join(', ');
  }

  /// Open the right editor for this card's kind.
  Future<void> _edit() async {
    switch (_type) {
      case ChartType.sensorGrid:
        await showLeakGridForm(
          context,
          dashboardId: _chart.dashboardId,
          existing: widget.item,
        );
      case ChartType.statTile:
        await showStatTileForm(
          context,
          dashboardId: _chart.dashboardId,
          existing: widget.item,
        );
      case ChartType.alertDuration:
        await showAlertDurationForm(
          context,
          dashboardId: _chart.dashboardId,
          existing: widget.item,
        );
      default:
        await showAddCurveSheet(
          context,
          dashboardId: _chart.dashboardId,
          existing: widget.item,
        );
    }
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

  Widget _buildCustom() {
    return switch (_type) {
      ChartType.sensorGrid => SensorGridView(item: _series.first),
      ChartType.statTile => StatTileView(item: _series.first),
      ChartType.alertDuration => AlertDurationView(
          item: _series.first,
          bucket: _bucket,
          anchor: _anchor,
        ),
      _ => const SizedBox.shrink(),
    };
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
              CircleIcon(icon: _type.icon, size: 38),
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
              // Reorder controls: swap this component with the one above /
              // below. Shown whenever the card can move in that direction
              // (i.e. the dashboard has more than one component).
              if (widget.onMoveUp != null || widget.onMoveDown != null)
                IconButton(
                  tooltip: l.moveUp,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.keyboard_arrow_up, size: 22),
                  color: AppColors.textMuted,
                  onPressed: widget.onMoveUp,
                ),
              if (widget.onMoveUp != null || widget.onMoveDown != null)
                IconButton(
                  tooltip: l.moveDown,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                  color: AppColors.textMuted,
                  onPressed: widget.onMoveDown,
                ),
              if (!_isCustom)
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
                      await _edit();
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
                  // Export is time-series only; custom components have no series.
                  if (!_isCustom) ...[
                    PopupMenuItem(value: 'csv', child: Text(l.exportCsv)),
                    PopupMenuItem(value: 'pdf', child: Text(l.exportPdf)),
                  ],
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
          // The time filter applies to time-series charts and the alert-duration
          // component (both sum/plot over the selected period); the other custom
          // components just show their current live state.
          if (_showsTimeFilter) ...[
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
                  onReset: () =>
                      setState(() => _anchor = defaultAnchor(_bucket)),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
          ],
          if (_isCustom)
            _buildCustom()
          else
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
