import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

/// The start of the current period for [bucket] (today / first-of-month /
/// first-of-year), used as the default anchor and to detect a non-default
/// selection.
DateTime defaultAnchor(TimeBucket bucket) {
  final n = DateTime.now();
  return switch (bucket) {
    TimeBucket.day => DateTime(n.year, n.month, n.day),
    TimeBucket.month => DateTime(n.year, n.month, 1),
    TimeBucket.year => DateTime(n.year, 1, 1),
  };
}

/// Localized label for the selected period, e.g. "1 Jul 2026" / "July 2026" /
/// "2026".
String formatPeriod(BuildContext context, TimeBucket bucket, DateTime anchor) {
  final locale = Localizations.localeOf(context).toString();
  return switch (bucket) {
    TimeBucket.day => DateFormat.yMMMd(locale).format(anchor),
    TimeBucket.month => DateFormat.yMMMM(locale).format(anchor),
    TimeBucket.year => DateFormat.y(locale).format(anchor),
  };
}

/// Opens the picker matching [bucket] and returns the chosen period start
/// (already normalized), or null if cancelled.
Future<DateTime?> pickPeriod(
  BuildContext context,
  TimeBucket bucket,
  DateTime current,
) async {
  switch (bucket) {
    case TimeBucket.day:
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: DateTime(2000),
        lastDate: DateTime(now.year, now.month, now.day),
      );
      return picked == null
          ? null
          : DateTime(picked.year, picked.month, picked.day);
    case TimeBucket.month:
      return showDialog<DateTime>(
        context: context,
        builder: (_) => _MonthYearDialog(initial: current),
      );
    case TimeBucket.year:
      return showDialog<DateTime>(
        context: context,
        builder: (_) => _YearDialog(initial: current),
      );
  }
}

/// Segmented Jour / Mois / Année selector with a trailing calendar button that
/// opens the period picker for the active bucket. When [onPickTimeRange] is
/// provided, a second (clock) button sits next to the calendar to pick a
/// time-of-day window; it is highlighted while [timeRangeActive].
class TimeFilter extends StatelessWidget {
  const TimeFilter({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onPickPeriod,
    this.onPickTimeRange,
    this.timeRangeActive = false,
  });

  final TimeBucket value;
  final ValueChanged<TimeBucket> onChanged;
  final VoidCallback onPickPeriod;

  /// Opens the time-of-day window picker. Null hides the clock button.
  final VoidCallback? onPickTimeRange;

  /// Whether a time-of-day window is currently applied (highlights the button).
  final bool timeRangeActive;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const labelStyle = TextStyle(fontSize: 11);
    ButtonSegment<TimeBucket> seg(TimeBucket bucket, String text) =>
        ButtonSegment(
          value: bucket,
          label: Text(
            text,
            style: labelStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clip to the rounded shape so the button never shows the dark backdrop
        // triangles that Impeller can leave in the corners outside its own shape.
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: SegmentedButton<TimeBucket>(
            showSelectedIcon: false,
            segments: [
              seg(TimeBucket.day, l.day),
              seg(TimeBucket.month, l.month),
              seg(TimeBucket.year, l.year),
            ],
            selected: {value},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ),
        IconButton(
          tooltip: l.pickPeriod,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.event, size: 20),
          onPressed: onPickPeriod,
        ),
        if (onPickTimeRange != null)
          IconButton(
            tooltip: l.timeRange,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.schedule,
              size: 20,
              color: timeRangeActive ? AppColors.primary : null,
            ),
            onPressed: onPickTimeRange,
          ),
      ],
    );
  }
}

/// Chip showing the selected non-default period with an X that resets it.
class PeriodChip extends StatelessWidget {
  const PeriodChip({super.key, required this.label, required this.onReset});

  final String label;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      onDeleted: onReset,
      deleteIcon: const Icon(Icons.close, size: 16),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// A remove/value/add stepper for a year, capped at the current year.
class _YearStepper extends StatelessWidget {
  const _YearStepper({required this.year, required this.onChanged});

  final int year;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final maxYear = DateTime.now().year;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: year > 2000 ? () => onChanged(year - 1) : null,
        ),
        Text(
          '$year',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: year < maxYear ? () => onChanged(year + 1) : null,
        ),
      ],
    );
  }
}

/// Month (dropdown) + year (stepper) picker, returning the first of the month.
class _MonthYearDialog extends StatefulWidget {
  const _MonthYearDialog({required this.initial});

  final DateTime initial;

  @override
  State<_MonthYearDialog> createState() => _MonthYearDialogState();
}

class _MonthYearDialogState extends State<_MonthYearDialog> {
  late int _year = widget.initial.year;
  late int _month = widget.initial.month;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final monthName = DateFormat.MMMM(locale);
    return AlertDialog(
      title: Text(l.selectMonth),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _YearStepper(year: _year, onChanged: (y) => setState(() => _year = y)),
          const SizedBox(height: AppSpacing.md),
          DropdownButton<int>(
            isExpanded: true,
            value: _month,
            items: [
              for (var m = 1; m <= 12; m++)
                DropdownMenuItem(
                  value: m,
                  child: Text(monthName.format(DateTime(2000, m))),
                ),
            ],
            onChanged: (m) => setState(() => _month = m ?? _month),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, DateTime(_year, _month, 1)),
          child: Text(l.ok),
        ),
      ],
    );
  }
}

/// Year-only picker, returning the first of January.
class _YearDialog extends StatefulWidget {
  const _YearDialog({required this.initial});

  final DateTime initial;

  @override
  State<_YearDialog> createState() => _YearDialogState();
}

class _YearDialogState extends State<_YearDialog> {
  late int _year = widget.initial.year;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.selectYear),
      content: _YearStepper(
        year: _year,
        onChanged: (y) => setState(() => _year = y),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, DateTime(_year, 1, 1)),
          child: Text(l.ok),
        ),
      ],
    );
  }
}
