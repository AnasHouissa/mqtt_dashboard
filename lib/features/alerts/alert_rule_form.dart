import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/alert_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../services/alert_engine.dart';
import '../../theme/app_theme.dart';
import '../../utils/number_format.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/sheet_action_bar.dart';
import '../../widgets/sheet_header.dart';
import '../dashboards/metric_dropdown.dart';
import 'alert_level_ui.dart';

/// Quick-fill offsets offered as chips next to the offset field. The field
/// itself stays free-form — these are shortcuts for the common `±10/20/30`
/// cases, not the only allowed values.
const _offsetPresets = [10.0, 20.0, 30.0, -10.0, -20.0, -30.0];

/// Bottom-sheet form to create or edit an alert rule and its severity levels.
class AlertRuleForm extends ConsumerStatefulWidget {
  const AlertRuleForm({super.key, this.rule});

  /// Non-null → editing an existing rule (save updates it in place).
  final AlertRuleWithConditions? rule;

  @override
  ConsumerState<AlertRuleForm> createState() => _AlertRuleFormState();
}

class _AlertRuleFormState extends ConsumerState<AlertRuleForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  int? _metricId;
  late bool _enabled;
  late final List<_ConditionDraft> _conditions;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _name = TextEditingController(text: rule?.rule.name ?? '');
    _metricId = rule?.rule.metricId;
    _enabled = rule?.rule.enabled ?? true;
    _conditions = rule == null
        ? [_ConditionDraft.empty()]
        : rule.conditions.map(_ConditionDraft.fromRow).toList();
  }

  @override
  void dispose() {
    _name.dispose();
    for (final c in _conditions) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_metricId == null) {
      showAppSnackBar(context, l.fieldRequired, isError: true);
      return;
    }
    if (_conditions.isEmpty) {
      showAppSnackBar(context, l.alertNeedsCondition, isError: true);
      return;
    }

    await ref.read(alertRepositoryProvider).saveRule(
          ruleId: widget.rule?.rule.id,
          name: _name.text.trim(),
          metricId: _metricId!,
          enabled: _enabled,
          conditions: [for (final c in _conditions) c.toDraft()],
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SheetHeader(
                      title: widget.rule == null ? l.addAlert : l.editAlert,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(labelText: l.alertName),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    MetricDropdown(
                      selected: _metricId,
                      onChanged: (v) => setState(() => _metricId = v),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l.alertConditions,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    for (var i = 0; i < _conditions.length; i++)
                      _ConditionTile(
                        key: ObjectKey(_conditions[i]),
                        draft: _conditions[i],
                        // The rule must keep at least one level, so the last
                        // one can't be removed.
                        onRemove: _conditions.length > 1
                            ? () => setState(() {
                                  _conditions.removeAt(i).dispose();
                                })
                            : null,
                        onChanged: () => setState(() {}),
                      ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: () => setState(
                            () => _conditions.add(_ConditionDraft.empty())),
                        icon: const Icon(Icons.add),
                        label: Text(l.addCondition),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppColors.primary,
                      title: Text(l.alertEnabled),
                      value: _enabled,
                      onChanged: (v) => setState(() => _enabled = v),
                    ),
                  ],
                ),
              ),
            ),
            SheetActionBar(
              onCancel: () => Navigator.pop(context),
              onSave: _save,
            ),
          ],
        ),
      ),
    );
  }
}

/// One severity level, shown as an accordion so a rule with several levels
/// stays compact until the user opens the one they want to edit.
class _ConditionTile extends StatelessWidget {
  const _ConditionTile({
    super.key,
    required this.draft,
    required this.onChanged,
    this.onRemove,
  });

  final _ConditionDraft draft;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final boolean = isBooleanComparison(draft.comparison);
    final threshold = draft.threshold;
    final summary = boolean
        ? conditionSummary(draft.comparison, 0, locale, l)
        : threshold == null
            ? '—'
            : conditionSummary(draft.comparison, threshold, locale, l);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: AppSpacing.md),
        leading: AlertLevelDot(level: draft.level, size: 12),
        title: Text(
          draft.level.label(l),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          summary,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: onRemove == null
            ? null
            : IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.textMuted),
                onPressed: onRemove,
              ),
        children: [
          // Numeric metrics need a threshold; on/off metrics (a door, a leak
          // detector) only need to know which state raises the alarm, so the
          // setpoint and offset fields would be noise.
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l.valueKindNumeric)),
              ButtonSegment(value: true, label: Text(l.valueKindBoolean)),
            ],
            selected: {boolean},
            showSelectedIcon: false,
            onSelectionChanged: (s) {
              draft.setBoolean(s.first);
              onChanged();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (boolean) ...[
            DropdownButtonFormField<AlertComparison>(
              initialValue: draft.comparison,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.alertState),
              items: [
                for (final c in const [
                  AlertComparison.isTrue,
                  AlertComparison.isFalse,
                ])
                  DropdownMenuItem(value: c, child: Text(c.label(l))),
              ],
              onChanged: (v) {
                if (v != null) {
                  draft.comparison = v;
                  onChanged();
                }
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.valueKindBooleanHint,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ] else ...[
            TextFormField(
              controller: draft.setpoint,
              decoration: InputDecoration(labelText: l.alertSetpoint),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              validator: (v) => (v == null || double.tryParse(v.trim()) == null)
                  ? l.invalidNumber
                  : null,
              onChanged: (_) => onChanged(),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<AlertComparison>(
              initialValue: draft.comparison,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.alertComparison),
              items: [
                for (final c in const [
                  AlertComparison.above,
                  AlertComparison.below,
                  AlertComparison.equals,
                ])
                  DropdownMenuItem(value: c, child: Text(c.label(l))),
              ],
              onChanged: (v) {
                if (v != null) {
                  draft.comparison = v;
                  onChanged();
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: draft.offset,
              decoration: InputDecoration(labelText: l.alertOffset),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              // Blank means no offset — only reject text that isn't a number.
              validator: (v) => (v == null ||
                      v.trim().isEmpty ||
                      double.tryParse(v.trim()) != null)
                  ? null
                  : l.invalidNumber,
              onChanged: (_) => onChanged(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final preset in _offsetPresets)
                  ActionChip(
                    label: Text(preset > 0
                        ? '+${formatMetricValue(preset, locale)}'
                        : formatMetricValue(preset, locale)),
                    onPressed: () {
                      // `_trim` so a chip writes "20", not "20.0".
                      draft.offset.text = _ConditionDraft._trim(preset);
                      onChanged();
                    },
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<AlertLevel>(
            initialValue: draft.level,
            isExpanded: true,
            decoration: InputDecoration(labelText: l.alertLevel),
            items: [
              for (final level in AlertLevel.values)
                DropdownMenuItem(
                  value: level,
                  child: Row(
                    children: [
                      AlertLevelDot(level: level),
                      const SizedBox(width: AppSpacing.sm),
                      Text(level.label(l)),
                    ],
                  ),
                ),
            ],
            onChanged: (v) {
              if (v != null) {
                draft.level = v;
                onChanged();
              }
            },
          ),
          if (boolean || threshold != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              boolean
                  ? l.alertTriggersWhenState(draft.comparison.label(l))
                  : l.alertTriggersWhen(
                      comparisonSymbol(draft.comparison),
                      formatMetricValue(threshold!, locale),
                    ),
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mutable editing state for one condition row.
class _ConditionDraft {
  _ConditionDraft({
    required this.setpoint,
    required this.offset,
    required this.comparison,
    required this.level,
  });

  factory _ConditionDraft.empty() => _ConditionDraft(
        setpoint: TextEditingController(),
        offset: TextEditingController(),
        comparison: AlertComparison.above,
        level: AlertLevel.warning,
      );

  factory _ConditionDraft.fromRow(AlertCondition row) => _ConditionDraft(
        setpoint: TextEditingController(text: _trim(row.setpoint)),
        offset: TextEditingController(
            text: row.offsetValue == 0 ? '' : _trim(row.offsetValue)),
        comparison: row.comparison,
        level: row.level,
      );

  final TextEditingController setpoint;
  final TextEditingController offset;
  AlertComparison comparison;
  AlertLevel level;

  /// Round numbers edit more naturally without a trailing `.0`.
  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  double? get _setpointValue => double.tryParse(setpoint.text.trim());
  double get _offsetValue => double.tryParse(offset.text.trim()) ?? 0;

  /// Null until the setpoint parses, so the summary can show a placeholder.
  double? get threshold {
    final s = _setpointValue;
    return s == null ? null : s + _offsetValue;
  }

  /// Switch between the numeric and on/off editors, defaulting each to its
  /// most common choice. The numeric fields keep whatever the user typed, so
  /// toggling back and forth never loses a half-entered threshold — but a
  /// boolean condition still saves a zero threshold (see [toDraft]).
  void setBoolean(bool value) {
    if (value == isBooleanComparison(comparison)) return;
    comparison =
        value ? AlertComparison.isTrue : AlertComparison.above;
  }

  AlertConditionDraft toDraft() {
    // A boolean condition ignores the threshold, so persist a clean zero
    // rather than whatever is left in the numeric fields.
    final boolean = isBooleanComparison(comparison);
    return AlertConditionDraft(
      setpoint: boolean ? 0 : (_setpointValue ?? 0),
      offsetValue: boolean ? 0 : _offsetValue,
      comparison: comparison,
      level: level,
    );
  }

  void dispose() {
    setpoint.dispose();
    offset.dispose();
  }
}

Future<void> showAlertRuleForm(
  BuildContext context, {
  AlertRuleWithConditions? rule,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => AlertRuleForm(rule: rule),
  );
}
