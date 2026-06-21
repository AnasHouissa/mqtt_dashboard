import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/color_swatch_picker.dart';
import '../../widgets/sheet_header.dart';
import '../charts/chart_series_editor.dart';

/// "Add curve" / "Edit curve": name the chart, then add one or more metric
/// series, each with its own type, color and visibility. Pass [existing] to
/// edit a chart in place instead of creating a new one.
class AddCurveSheet extends ConsumerStatefulWidget {
  const AddCurveSheet({
    super.key,
    required this.dashboardId,
    this.existing,
  });

  final int dashboardId;
  final ChartWithSeries? existing;

  @override
  ConsumerState<AddCurveSheet> createState() => _AddCurveSheetState();
}

class _AddCurveSheetState extends ConsumerState<AddCurveSheet> {
  final _title = TextEditingController();
  final _drafts = <SeriesDraft>[];

  /// Index of the currently expanded series card (-1 = all collapsed). Only one
  /// is open at a time to keep the list short.
  int _expanded = 0;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    if (existing != null) {
      _title.text = existing.chart.title ?? '';
      for (final s in existing.series) {
        _drafts.add(
          SeriesDraft(
            metricId: s.series.metricId,
            type: s.series.type,
            color: Color(s.series.color),
            visible: s.series.visible,
          ),
        );
      }
    }
    if (_drafts.isEmpty) _drafts.add(_newDraft());
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  /// A fresh series with the next palette color (cycling).
  SeriesDraft _newDraft() =>
      SeriesDraft(color: kChartPalette[_drafts.length % kChartPalette.length]);

  void _addSeries() => setState(() {
    _drafts.add(_newDraft());
    _expanded = _drafts.length - 1; // open the new one
  });

  void _removeSeries(int index) => setState(() {
    _drafts.removeAt(index);
    if (_expanded >= _drafts.length) _expanded = _drafts.length - 1;
  });

  void _toggle(int index) =>
      setState(() => _expanded = _expanded == index ? -1 : index);

  bool get _canSave => _drafts.any((d) => d.metricId != null);

  Future<void> _save() async {
    final series = [
      for (final d in _drafts)
        if (d.metricId != null)
          ChartSeriesDraft(
            metricId: d.metricId!,
            type: d.type,
            color: d.color.toARGB32(),
            visible: d.visible,
          ),
    ];
    if (series.isEmpty) return;
    final repo = ref.read(dashboardRepositoryProvider);
    final title = _title.text.trim().isEmpty ? null : _title.text.trim();
    final existing = widget.existing;
    if (existing != null) {
      await repo.updateChartWithSeries(
        chartId: existing.chart.id,
        title: title,
        series: series,
      );
    } else {
      await repo.createChartWithSeries(
        dashboardId: widget.dashboardId,
        title: title,
        series: series,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final metrics = ref.watch(allMetricsProvider);
    // Metrics can come from several data sources, so map each source's id to its
    // name to label metrics and disambiguate same-named topics. Broker ids and
    // SMS-source ids live in separate id spaces, so keep two maps.
    final sourceNames = {
      for (final b
          in ref.watch(brokersProvider).valueOrNull ?? const <Broker>[])
        b.id: b.name,
    };
    final smsSourceNames = {
      for (final s
          in ref.watch(smsSourcesProvider).valueOrNull ?? const <SmsSource>[])
        s.id: s.name,
    };

    return metrics.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: SheetHeader(title: _isEditing ? l.editCurve : l.addCurve),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // 1) Chart title comes first.
                  TextField(
                    controller: _title,
                    decoration: InputDecoration(labelText: l.chartTitle),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (list.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      child: Text(l.noMetrics),
                    )
                  else ...[
                    // 2) One or more metric series (collapsible, one open).
                    for (var i = 0; i < _drafts.length; i++)
                      ChartSeriesEditor(
                        key: ValueKey(_drafts[i]),
                        metrics: list,
                        sourceNames: sourceNames,
                        smsSourceNames: smsSourceNames,
                        draft: _drafts[i],
                        expanded: _expanded == i,
                        onToggle: () => _toggle(i),
                        onChanged: () => setState(() {}),
                        onRemove: _drafts.length > 1
                            ? () => _removeSeries(i)
                            : null,
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: _addSeries,
                      icon: const Icon(Icons.add),
                      label: Text(l.addMetricSeries),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(0, 48),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Sticky action bar pinned above the keyboard.
            _ActionBar(
              onCancel: () => Navigator.pop(context),
              onSave: _canSave ? _save : null,
            ),
          ],
        );
      },
    );
  }
}

/// Pinned Cancel / Save bar at the bottom of the sheet.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.onCancel, this.onSave});

  final VoidCallback onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(onPressed: onCancel, child: Text(l.cancel)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: FilledButton(onPressed: onSave, child: Text(l.save)),
          ),
        ],
      ),
    );
  }
}

Future<void> showAddCurveSheet(
  BuildContext context, {
  required int dashboardId,
  ChartWithSeries? existing,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FractionallySizedBox(
        heightFactor: 1,
        child: AddCurveSheet(
          dashboardId: dashboardId,
          existing: existing,
        ),
      ),
    ),
  );
}
