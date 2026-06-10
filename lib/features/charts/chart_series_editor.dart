import 'package:flutter/material.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/color_swatch_picker.dart';
import 'chart_type_ui.dart';

/// Mutable description of one chart series while it is being edited. Shared
/// between the editor and the create/edit sheets.
class SeriesDraft {
  SeriesDraft({
    this.metricId,
    this.type = ChartType.line,
    required this.color,
    this.visible = true,
  });

  int? metricId;
  ChartType type;
  Color color;
  bool visible;
}

/// The reusable `{metric, type, color, visibility}` group. Edits [draft] in
/// place and notifies the parent via [onChanged] so it can rebuild.
class ChartSeriesEditor extends StatelessWidget {
  const ChartSeriesEditor({
    super.key,
    required this.metrics,
    required this.draft,
    required this.onChanged,
    this.onRemove,
  });

  final List<Metric> metrics;
  final SeriesDraft draft;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: draft.metricId,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l.selectMetric),
                  items: [
                    for (final m in metrics)
                      DropdownMenuItem(value: m.id, child: Text(m.name)),
                  ],
                  onChanged: (v) {
                    draft.metricId = v;
                    onChanged();
                  },
                ),
              ),
              if (onRemove != null)
                IconButton(
                  tooltip: l.delete,
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: onRemove,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final type in ChartType.values)
                ChoiceChip(
                  selected: draft.type == type,
                  showCheckmark: false,
                  avatar: Icon(
                    type.icon,
                    size: 18,
                    color: draft.type == type
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                  label: Text(type.label(l)),
                  labelStyle: TextStyle(
                    color: draft.type == type
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.scaffold,
                  side: const BorderSide(color: AppColors.divider),
                  onSelected: (_) {
                    draft.type = type;
                    onChanged();
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.color,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ColorSwatchPicker(
            selected: draft.color,
            onChanged: (c) {
              draft.color = c;
              onChanged();
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primary,
            title: Text(l.showInChart),
            value: draft.visible,
            onChanged: (v) {
              draft.visible = v;
              onChanged();
            },
          ),
        ],
      ),
    );
  }
}
