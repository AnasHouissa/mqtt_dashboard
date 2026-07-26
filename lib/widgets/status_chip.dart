import 'package:flutter/material.dart';

/// A small pill labelling the state of a log row — the SMS parse outcome, an
/// alert's severity — drawn as bold colored text on a 12% tint of the same
/// color.
///
/// Distinct from `StatusPill`, which pairs a dot with a label for the live MQTT
/// connection state; this one is the flatter, denser variant used inside cards.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
