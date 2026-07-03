import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/color_picker_field.dart';
import '../../widgets/sheet_action_bar.dart';
import '../../widgets/sheet_header.dart';
import 'metric_dropdown.dart';

/// Default empty/OK cell color (a soft grey) when none is chosen.
const _kDefaultEmptyColor = 0xFFCBD2DC;

/// Allowed sensor counts — always a multiple of 4 (one row of cells).
const _kSensorCounts = [4, 8, 12];

/// "Add / edit leak grid": name it, bind a metric, choose how many sensors and
/// the alert (fill) + cleared (empty) colors. Pass [existing] to edit in place.
class LeakGridForm extends ConsumerStatefulWidget {
  const LeakGridForm({super.key, required this.dashboardId, this.existing});

  final int dashboardId;
  final ChartWithSeries? existing;

  @override
  ConsumerState<LeakGridForm> createState() => _LeakGridFormState();
}

class _LeakGridFormState extends ConsumerState<LeakGridForm> {
  final _title = TextEditingController();
  int? _metricId;
  int _sensorCount = 4;
  Color _fillColor = AppColors.danger;
  Color _emptyColor = const Color(_kDefaultEmptyColor);

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      final s = existing.series.first.series;
      _title.text = existing.chart.title ?? '';
      _metricId = s.metricId;
      _sensorCount = s.sensorCount ?? 4;
      _fillColor = Color(s.fillColor ?? AppColors.danger.toARGB32());
      _emptyColor = Color(s.emptyColor ?? _kDefaultEmptyColor);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  bool get _canSave => _metricId != null;

  Future<void> _save() async {
    final metricId = _metricId;
    if (metricId == null) return;
    final draft = ChartSeriesDraft(
      metricId: metricId,
      type: ChartType.sensorGrid,
      color: _fillColor.toARGB32(),
      visible: true,
      sensorCount: _sensorCount,
      fillColor: _fillColor.toARGB32(),
      emptyColor: _emptyColor.toARGB32(),
    );
    final repo = ref.read(dashboardRepositoryProvider);
    final title = _title.text.trim().isEmpty ? null : _title.text.trim();
    final existing = widget.existing;
    if (existing != null) {
      await repo.updateChartWithSeries(
        chartId: existing.chart.id,
        title: title,
        series: [draft],
      );
    } else {
      await repo.createChartWithSeries(
        dashboardId: widget.dashboardId,
        title: title,
        series: [draft],
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            0,
          ),
          child: SheetHeader(title: _isEditing ? l.editLeakGrid : l.addLeakGrid),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              TextField(
                controller: _title,
                decoration: InputDecoration(labelText: l.name),
              ),
              const SizedBox(height: AppSpacing.lg),
              MetricDropdown(
                selected: _metricId,
                onChanged: (v) => setState(() => _metricId = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l.sensorCount,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  for (final c in _kSensorCounts)
                    ButtonSegment(value: c, label: Text('$c')),
                ],
                selected: {_sensorCount},
                onSelectionChanged: (s) =>
                    setState(() => _sensorCount = s.first),
              ),
              const SizedBox(height: AppSpacing.md),
              ColorPickerField(
                label: l.fillColor,
                color: _fillColor,
                onChanged: (c) => setState(() => _fillColor = c),
              ),
              ColorPickerField(
                label: l.emptyColor,
                color: _emptyColor,
                onChanged: (c) => setState(() => _emptyColor = c),
              ),
            ],
          ),
        ),
        SheetActionBar(
          onCancel: () => Navigator.pop(context),
          onSave: _canSave ? _save : null,
        ),
      ],
    );
  }
}

Future<void> showLeakGridForm(
  BuildContext context, {
  required int dashboardId,
  ChartWithSeries? existing,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: 1,
        child: LeakGridForm(dashboardId: dashboardId, existing: existing),
      ),
    ),
  );
}
