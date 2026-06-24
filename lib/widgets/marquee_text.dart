import 'package:flutter/material.dart';

/// Single-line text on a horizontal scroll view. When the text is wider than
/// the available space it auto-scrolls back and forth like a banner, and the
/// user can also drag it manually — auto-scroll pauses while they interact and
/// resumes afterwards. Short text that fits just sits still.
///
/// Always reports a definite height (the measured line height) so it lays out
/// correctly inside constrained slots such as `DropdownMenuItem`s.
class MarqueeText extends StatefulWidget {
  const MarqueeText(
    this.text, {
    super.key,
    this.style,
    this.velocity = 30,
  });

  final String text;
  final TextStyle? style;

  /// Auto-scroll speed in logical pixels per second. Lower is slower.
  final double velocity;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  final _controller = ScrollController();
  bool _disposed = false;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoScroll());
  }

  /// Continuously animates the scroll offset to the far end and back, pausing
  /// briefly at each end and whenever the user is dragging.
  Future<void> _autoScroll() async {
    while (!_disposed) {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (_disposed || !_controller.hasClients) continue;
      final max = _controller.position.maxScrollExtent;
      // Nothing to scroll (text fits) or the user is dragging: idle this tick.
      if (max <= 0 || _userInteracting) continue;

      final target = _controller.offset < max ? max : 0.0;
      final distance = (target - _controller.offset).abs();
      final ms = (distance / widget.velocity * 1000).round().clamp(300, 60000);
      try {
        await _controller.animateTo(
          target,
          duration: Duration(milliseconds: ms),
          curve: Curves.linear,
        );
      } catch (_) {
        // Position can be disposed/replaced mid-animation; ignore and retry.
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final scaler = MediaQuery.textScalerOf(context);
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      maxLines: 1,
      textScaler: scaler,
      textDirection: Directionality.of(context),
    )..layout();

    return SizedBox(
      height: painter.height,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is ScrollStartNotification && n.dragDetails != null) {
            _userInteracting = true;
          } else if (n is ScrollEndNotification) {
            _userInteracting = false;
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Text(
            widget.text,
            style: style,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}
