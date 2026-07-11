import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sheet_header.dart';

/// A start/end date-time window chosen by the user.
typedef PickedRange = ({DateTime start, DateTime end});

/// Opens a sheet letting the user pick a start and end date + time, returning
/// the chosen [PickedRange] (or null if cancelled). Reused for exporting and
/// for deleting a metric's history. Defaults to "start of today → now".
/// [confirmDanger] styles the confirm button as destructive (used for delete).
Future<PickedRange?> showDateTimeRangeSheet(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  bool confirmDanger = false,
}) {
  final now = DateTime.now();
  return showModalBottomSheet<PickedRange>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _DateTimeRangeSheet(
        title: title,
        confirmLabel: confirmLabel,
        confirmDanger: confirmDanger,
        initialStart: DateTime(now.year, now.month, now.day),
        initialEnd: now,
      ),
    ),
  );
}

class _DateTimeRangeSheet extends StatefulWidget {
  const _DateTimeRangeSheet({
    required this.title,
    required this.confirmLabel,
    required this.confirmDanger,
    required this.initialStart,
    required this.initialEnd,
  });

  final String title;
  final String confirmLabel;
  final bool confirmDanger;
  final DateTime initialStart;
  final DateTime initialEnd;

  @override
  State<_DateTimeRangeSheet> createState() => _DateTimeRangeSheetState();
}

class _DateTimeRangeSheetState extends State<_DateTimeRangeSheet> {
  late DateTime _start = widget.initialStart;
  late DateTime _end = widget.initialEnd;

  bool get _valid => !_start.isAfter(_end);

  /// Pick a date then a time, combining them into one [DateTime].
  Future<DateTime?> _pickDateTime(DateTime current) async {
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (time == null) return null;
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetHeader(title: widget.title),
          const SizedBox(height: AppSpacing.lg),
          _RangeField(
            label: l.from,
            value: _start,
            onTap: () async {
              final picked = await _pickDateTime(_start);
              if (picked != null) setState(() => _start = picked);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _RangeField(
            label: l.to,
            value: _end,
            onTap: () async {
              final picked = await _pickDateTime(_end);
              if (picked != null) setState(() => _end = picked);
            },
          ),
          if (!_valid) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.invalidRange,
              style: const TextStyle(color: AppColors.danger, fontSize: 13),
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
                style: widget.confirmDanger
                    ? FilledButton.styleFrom(backgroundColor: AppColors.danger)
                    : null,
                onPressed: _valid
                    ? () => Navigator.pop(context, (start: _start, end: _end))
                    : null,
                child: Text(widget.confirmLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A labelled, tappable field showing a formatted date + time.
class _RangeField extends StatelessWidget {
  const _RangeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final formatted = DateFormat.yMMMd(locale).add_Hm().format(value);
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.button),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.event, size: 20),
        ),
        child: Text(formatted, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
