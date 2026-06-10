import 'package:flutter/material.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';

/// Segmented Jour / Mois / Année selector.
class TimeFilter extends StatelessWidget {
  const TimeFilter({super.key, required this.value, required this.onChanged});

  final TimeBucket value;
  final ValueChanged<TimeBucket> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SegmentedButton<TimeBucket>( showSelectedIcon: false,
      segments: [
        ButtonSegment(value: TimeBucket.today, label: Text(l.today,style: TextStyle(fontSize: 11),)),
        ButtonSegment(value: TimeBucket.day, label: Text(l.day,style: TextStyle(fontSize: 11),)),
        ButtonSegment(value: TimeBucket.month, label: Text(l.month,style: TextStyle(fontSize: 11),)),
        ButtonSegment(value: TimeBucket.year, label: Text(l.year,style: TextStyle(fontSize: 11),)),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
