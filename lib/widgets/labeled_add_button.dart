import 'package:flutter/material.dart';

/// A compact, labeled action button for app bars — an icon plus a verb so the
/// action is unambiguous (e.g. "Add metric"). Used wherever a bare "+" would be
/// unclear about *what* gets added.
class LabeledAddButton extends StatelessWidget {
  const LabeledAddButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
      ),
    );
  }
}
