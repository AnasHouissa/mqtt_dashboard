import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../../widgets/marquee_text.dart';

/// A single-metric picker used by the custom-component forms (leak grid / stat
/// tile). Lists every metric across all data sources, labelled
/// "name · topic · source" so same-named topics stay distinguishable.
class MetricDropdown extends ConsumerWidget {
  const MetricDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final int? selected;
  final ValueChanged<int?> onChanged;

  static String label(
    Metric m,
    Map<int, String> sourceNames,
    Map<int, String> smsSourceNames,
  ) {
    final source = m.sourceKind == MetricSourceKind.sms
        ? smsSourceNames[m.smsSourceId]
        : sourceNames[m.brokerId];
    return [m.name, m.topic, ?source].join(' · ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final metrics = ref.watch(allMetricsProvider);
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
      error: (e, _) => Text('$e'),
      data: (list) {
        if (list.isEmpty) return Text(l.noMetrics);
        return DropdownButtonFormField<int>(
          initialValue: selected,
          isExpanded: true,
          decoration: InputDecoration(labelText: l.dataSource),
          items: [
            for (final m in list)
              DropdownMenuItem(
                value: m.id,
                child: MarqueeText(label(m, sourceNames, smsSourceNames)),
              ),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}
