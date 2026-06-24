import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shows a snackbar-style message in the **root overlay** so it is always
/// visible above modal bottom sheets and dialogs.
///
/// A normal `ScaffoldMessenger.of(context).showSnackBar(...)` renders inside the
/// page's `Scaffold`, which sits *below* any pushed route (a bottom sheet,
/// dialog, …) and is therefore hidden behind it. Inserting into the root
/// overlay puts the message on the very top layer instead.
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _AppSnackBar(
      message: message,
      isError: isError,
      duration: duration,
      onDismissed: entry.remove,
    ),
  );
  overlay.insert(entry);
}

/// Animated snackbar body that slides up, waits [duration], then slides out and
/// removes itself via [onDismissed].
class _AppSnackBar extends StatefulWidget {
  const _AppSnackBar({
    required this.message,
    required this.isError,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final bool isError;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_AppSnackBar> createState() => _AppSnackBarState();
}

class _AppSnackBarState extends State<_AppSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_removed || !mounted) return;
    await _controller.reverse();
    if (_removed) return;
    _removed = true;
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      bottom: AppSpacing.lg,
      child: SafeArea(
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(_curve),
          child: FadeTransition(
            opacity: _curve,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isError
                        ? AppColors.danger
                        : AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
