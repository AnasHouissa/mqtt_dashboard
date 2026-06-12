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

/// The reusable `{metric, type, color, visibility}` group, rendered as a
/// collapsible card: a compact summary header that expands to the full editor.
/// Edits [draft] in place and notifies the parent via [onChanged].
class ChartSeriesEditor extends StatelessWidget {
  const ChartSeriesEditor({
    super.key,
    required this.metrics,
    required this.draft,
    required this.onChanged,
    required this.expanded,
    required this.onToggle,
    this.onRemove,
  });

  final List<Metric> metrics;
  final SeriesDraft draft;
  final VoidCallback onChanged;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback? onRemove;

  String? get _metricName {
    if (draft.metricId == null) return null;
    for (final m in metrics) {
      if (m.id == draft.metricId) return m.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, l),
          if (expanded) ...[
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            _body(context, l),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  Widget _header(BuildContext context, AppLocalizations l) {
    final name = _metricName;
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: draft.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                name ?? l.selectMetric,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: name == null
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                ),
              ),
            ),
            if (!expanded) ...[
              if (!draft.visible)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(Icons.visibility_off,
                      size: 16, color: AppColors.textMuted),
                ),
              Text(
                draft.type.label(l),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.textMuted,
            ),
            if (onRemove != null)
              IconButton(
                tooltip: l.delete,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close, color: AppColors.danger),
                onPressed: onRemove,
              ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
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
    );
  }
}
