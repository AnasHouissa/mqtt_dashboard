import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

/// "Ajouter courbe": pick a metric, chart type and optional title.
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
  int? _metricId;
  ChartType _type = ChartType.line;
  final _title = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final metricId = _metricId;
    if (metricId == null) return;
    await ref.read(dashboardRepositoryProvider).insertChart(
          ChartsCompanion.insert(
            dashboardId: widget.dashboardId,
            metricId: metricId,
            type: _type,
            title: Value(_title.text.trim().isEmpty ? null : _title.text.trim()),
          ),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final metrics = ref.watch(metricsProvider(widget.brokerId));

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.addCurve, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          metrics.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
            data: (list) {
              if (list.isEmpty) return Text(l.noMetrics);
              return DropdownButtonFormField<int>(
                initialValue: _metricId,
                decoration: InputDecoration(labelText: l.selectMetric),
                items: [
                  for (final m in list)
                    DropdownMenuItem(value: m.id, child: Text(m.name)),
                ],
                onChanged: (v) => setState(() => _metricId = v),
              );
            },
          ),
          const SizedBox(height: 12),
          SegmentedButton<ChartType>(
            segments: [
              ButtonSegment(
                value: ChartType.line,
                label: Text(l.curve),
                icon: const Icon(Icons.show_chart),
              ),
              ButtonSegment(
                value: ChartType.histogram,
                label: Text(l.histogram),
                icon: const Icon(Icons.bar_chart),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: l.chartTitle),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.cancel),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _metricId == null ? null : _save,
                child: Text(l.save),
              ),
            ],
          ),
        ],
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
