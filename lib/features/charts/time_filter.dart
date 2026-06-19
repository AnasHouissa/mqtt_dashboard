import 'package:flutter/material.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

/// Segmented Aujourd'hui / Jour / Mois / Année selector.
class TimeFilter extends StatelessWidget {
  const TimeFilter({super.key, required this.value, required this.onChanged});

  final TimeBucket value;
  final ValueChanged<TimeBucket> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const labelStyle = TextStyle(fontSize: 11);
    // Clip to the rounded shape so the button never shows the dark backdrop
    // triangles that Impeller can leave in the corners outside its own shape.
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: SegmentedButton<TimeBucket>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: TimeBucket.today,
            label: Text(l.today, style: labelStyle),
          ),
          ButtonSegment(
            value: TimeBucket.day,
            label: Text(l.day, style: labelStyle),
          ),
          ButtonSegment(
            value: TimeBucket.month,
            label: Text(l.month, style: labelStyle),
          ),
          ButtonSegment(
            value: TimeBucket.year,
            label: Text(l.year, style: labelStyle),
          ),
        ],
        selected: {value},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}
