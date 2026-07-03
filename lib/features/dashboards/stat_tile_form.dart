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

/// "Add / edit stat tile": name it, bind a metric, set the unit and the
/// background + foreground (text/border) colors. Pass [existing] to edit.
class StatTileForm extends ConsumerStatefulWidget {
  const StatTileForm({super.key, required this.dashboardId, this.existing});

  final int dashboardId;
  final ChartWithSeries? existing;

  @override
  ConsumerState<StatTileForm> createState() => _StatTileFormState();
}

class _StatTileFormState extends ConsumerState<StatTileForm> {
  final _title = TextEditingController();
  final _unit = TextEditingController();
  int? _metricId;
  Color _bgColor = AppColors.primarySoft;
  Color _fgColor = AppColors.primary;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      final s = existing.series.first.series;
      _title.text = existing.chart.title ?? '';
      _unit.text = s.unit ?? '';
      _metricId = s.metricId;
      _bgColor = Color(s.bgColor ?? AppColors.primarySoft.toARGB32());
      _fgColor = Color(s.fgColor ?? AppColors.primary.toARGB32());
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _unit.dispose();
    super.dispose();
  }

  bool get _canSave => _metricId != null;

  Future<void> _save() async {
    final metricId = _metricId;
    if (metricId == null) return;
    final unit = _unit.text.trim();
    final draft = ChartSeriesDraft(
      metricId: metricId,
      type: ChartType.statTile,
      color: _fgColor.toARGB32(),
      visible: true,
      unit: unit.isEmpty ? null : unit,
      bgColor: _bgColor.toARGB32(),
      fgColor: _fgColor.toARGB32(),
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
          child: SheetHeader(title: _isEditing ? l.editStatTile : l.addStatTile),
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
              TextField(
                controller: _unit,
                decoration: InputDecoration(labelText: l.unit),
              ),
              const SizedBox(height: AppSpacing.md),
              ColorPickerField(
                label: l.backgroundColor,
                color: _bgColor,
                onChanged: (c) => setState(() => _bgColor = c),
              ),
              ColorPickerField(
                label: l.foregroundColor,
                color: _fgColor,
                onChanged: (c) => setState(() => _fgColor = c),
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

Future<void> showStatTileForm(
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
        child: StatTileForm(dashboardId: dashboardId, existing: existing),
      ),
    ),
  );
}
