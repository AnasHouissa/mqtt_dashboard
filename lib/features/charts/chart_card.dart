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

/// A dashboard chart with its own time filter, fullscreen + edit/delete.
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

  /// Optional time-of-day window applied only to the day bucket; null = full day.
  TimeOfDay? _dayStart;
  TimeOfDay? _dayEnd;

  bool get _isDefault => _anchor == defaultAnchor(_bucket);

  int? get _startMinutes =>
      _dayStart == null ? null : _dayStart!.hour * 60 + _dayStart!.minute;
  int? get _endMinutes =>
      _dayEnd == null ? null : _dayEnd!.hour * 60 + _dayEnd!.minute;

  void _selectBucket(TimeBucket b) => setState(() {
    _bucket = b;
    _anchor = defaultAnchor(b); // start each tab at its current period
    _dayStart = null; // the time window only applies to a day
    _dayEnd = null;
  });

  Future<void> _pickPeriod() async {
    final picked = await pickPeriod(context, _bucket, _anchor);
    if (picked != null) setState(() => _anchor = picked);
  }

  /// Pick a start then an end time to narrow the day to a window. Swaps them if
  /// the end precedes the start so the range is always valid.
  Future<void> _pickDayTimeRange() async {
    final start = await showTimePicker(
      context: context,
      initialTime: _dayStart ?? const TimeOfDay(hour: 0, minute: 0),
      helpText: AppLocalizations.of(context).from,
    );
    if (start == null || !mounted) return;
    final end = await showTimePicker(
      context: context,
      initialTime: _dayEnd ?? const TimeOfDay(hour: 23, minute: 59),
      helpText: AppLocalizations.of(context).to,
    );
    if (end == null) return;
    final startMin = start.hour * 60 + start.minute;
    final endMin = end.hour * 60 + end.minute;
    setState(() {
      _dayStart = endMin < startMin ? end : start;
      _dayEnd = endMin < startMin ? start : end;
    });
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

  void _openFullscreen() {
    // Push on the root navigator so the landscape fullscreen chart covers the
    // sticky bottom nav bar (the only screen that hides it).
    Navigator.of(context, rootNavigator: true).push(
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
            // Time-of-day window: only meaningful for a day-bucket time-series
            // chart. A tap opens start/end time pickers; a set window shows a
            // resettable chip.
            if (!_isCustom && _bucket == TimeBucket.day) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: _dayStart == null || _dayEnd == null
                    ? ActionChip(
                        avatar: const Icon(Icons.schedule, size: 18),
                        label: Text(l.timeRange),
                        onPressed: _pickDayTimeRange,
                      )
                    : PeriodChip(
                        label:
                            '${_dayStart!.format(context)} – ${_dayEnd!.format(context)}',
                        onReset: () => setState(() {
                          _dayStart = null;
                          _dayEnd = null;
                        }),
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
                startMinutes: _startMinutes,
                endMinutes: _endMinutes,
              ),
            ),
        ],
      ),
    );
  }
}
