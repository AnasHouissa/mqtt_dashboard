import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dashboard_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/color_swatch_picker.dart';
import '../../widgets/sheet_header.dart';
import '../charts/chart_series_editor.dart';

/// "Add curve": name the chart, then add one or more metric series, each with
/// its own type, color and visibility.
class AddCurveSheet extends ConsumerStatefulWidget {
  const AddCurveSheet({
    super.key,
    required this.brokerId,
    required this.dashboardId,
  });

  final int brokerId;
  final int dashboardId;

  @override
  ConsumerState<AddCurveSheet> createState() => _AddCurveSheetState();
}

class _AddCurveSheetState extends ConsumerState<AddCurveSheet> {
  final _title = TextEditingController();
  final _drafts = <SeriesDraft>[];

  @override
  void initState() {
    super.initState();
    _drafts.add(_newDraft());
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  /// A fresh series with the next palette color (cycling).
  SeriesDraft _newDraft() =>
      SeriesDraft(color: kChartPalette[_drafts.length % kChartPalette.length]);

  void _addSeries() => setState(() => _drafts.add(_newDraft()));

  void _removeSeries(int index) => setState(() => _drafts.removeAt(index));

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
    await ref.read(dashboardRepositoryProvider).createChartWithSeries(
          dashboardId: widget.dashboardId,
          title: _title.text.trim().isEmpty ? null : _title.text.trim(),
          series: series,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final metrics = ref.watch(metricsProvider(widget.brokerId));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) => metrics.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                SheetHeader(title: l.addCurve),
                const SizedBox(height: AppSpacing.lg),
                // 1) Chart title comes first.
                TextField(
                  controller: _title,
                  decoration: InputDecoration(labelText: l.chartTitle),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (list.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Text(l.noMetrics),
                  )
                else ...[
                  // 2) One or more metric series.
                  for (var i = 0; i < _drafts.length; i++)
                    ChartSeriesEditor(
                      key: ValueKey(_drafts[i]),
                      metrics: list,
                      draft: _drafts[i],
                      onChanged: () => setState(() {}),
                      onRemove:
                          _drafts.length > 1 ? () => _removeSeries(i) : null,
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
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l.cancel),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton(
                      onPressed: _canSave ? _save : null,
                      child: Text(l.save),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> showAddCurveSheet(
  BuildContext context, {
  required int brokerId,
  required int dashboardId,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) =>
        AddCurveSheet(brokerId: brokerId, dashboardId: dashboardId),
  );
}
