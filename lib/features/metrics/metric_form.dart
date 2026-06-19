import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sheet_header.dart';

/// Bottom-sheet form to create or edit a metric.
class MetricForm extends ConsumerStatefulWidget {
  const MetricForm({super.key, required this.brokerId, this.metric});

  final int brokerId;
  final Metric? metric;

  @override
  ConsumerState<MetricForm> createState() => _MetricFormState();
}

class _MetricFormState extends ConsumerState<MetricForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _topic;
  late final TextEditingController _min;
  late final TextEditingController _max;
  late bool _publishEnabled;
  late bool _useFixedRange;

  @override
  void initState() {
    super.initState();
    final m = widget.metric;
    _name = TextEditingController(text: m?.name ?? '');
    _topic = TextEditingController(text: m?.topic ?? '');
    _min = TextEditingController(text: m?.minValue?.toString() ?? '');
    _max = TextEditingController(text: m?.maxValue?.toString() ?? '');
    _publishEnabled = m?.publishEnabled ?? false;
    _useFixedRange = m?.useFixedRange ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _topic.dispose();
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  double? _parseOptional(String text) =>
      text.trim().isEmpty ? null : double.tryParse(text.trim());

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final minV = _parseOptional(_min.text);
    final maxV = _parseOptional(_max.text);
    // A fixed chart range needs both bounds; block save with a clear message.
    if (_useFixedRange && (minV == null || maxV == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).rangeRequiresMinMax),
        ),
      );
      return;
    }
    final repo = ref.read(metricRepositoryProvider);

    if (widget.metric == null) {
      await repo.insert(
        MetricsCompanion.insert(
          brokerId: widget.brokerId,
          name: _name.text.trim(),
          topic: _topic.text.trim(),
          publishEnabled: Value(_publishEnabled),
          minValue: Value(minV),
          maxValue: Value(maxV),
          useFixedRange: Value(_useFixedRange),
        ),
      );
    } else {
      await repo.update(
        widget.metric!.copyWith(
          name: _name.text.trim(),
          topic: _topic.text.trim(),
          publishEnabled: _publishEnabled,
          minValue: Value(minV),
          maxValue: Value(maxV),
          useFixedRange: _useFixedRange,
        ),
      );
    }
    // Resync MQTT subscriptions if this broker is connected.
    await ref.read(connectionProvider.notifier).refreshSubscriptions();
    if (mounted) Navigator.pop(context);
  }

  String? _numberValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return double.tryParse(v.trim()) == null
        ? AppLocalizations.of(context).invalidNumber
        : null;
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
                      title: widget.metric == null ? l.addMetric : l.editMetric,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(labelText: l.metricName),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _topic,
                      decoration: InputDecoration(labelText: l.topic),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _min,
                            decoration: InputDecoration(labelText: l.minValue),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            validator: _numberValidator,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _max,
                            decoration: InputDecoration(labelText: l.maxValue),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            validator: _numberValidator,
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppColors.primary,
                      title: Text(l.fixedChartRange),
                      subtitle: Text(
                        _useFixedRange
                            ? l.fixedChartRangeOn
                            : l.fixedChartRangeOff,
                      ),
                      value: _useFixedRange,
                      onChanged: (v) => setState(() => _useFixedRange = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppColors.primary,
                      title: Text(l.enablePublishing),
                      value: _publishEnabled,
                      onChanged: (v) => setState(() => _publishEnabled = v),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, AppSpacing.md, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton(onPressed: _save, child: Text(l.save)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showMetricForm(
  BuildContext context, {
  required int brokerId,
  Metric? metric,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => MetricForm(brokerId: brokerId, metric: metric),
  );
}
