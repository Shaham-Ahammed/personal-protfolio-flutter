import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedNameText extends StatefulWidget {
  const AnimatedNameText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.onCompleted,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final VoidCallback? onCompleted;

  @override
  State<AnimatedNameText> createState() => _AnimatedNameTextState();
}

class _AnimatedNameTextState extends State<AnimatedNameText> {
  late int _visibleChars;
  late bool _cursorOn;
  Timer? _charTimer;
  Timer? _cursorTimer;
  final _rand = Random();
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _visibleChars = 0;
    _cursorOn = true;
    _startAnimation();
  }

  void _startAnimation() {
    const startDelay = Duration(milliseconds: 300);
    Future.delayed(startDelay, () {
      if (!mounted) return;
      _startCursorBlink();
      _scheduleNextChar();
    });
  }

  void _startCursorBlink() {
    _cursorTimer?.cancel();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        _cursorOn = !_cursorOn;
      });
    });
  }

  void _scheduleNextChar() {
    if (_visibleChars >= widget.text.length) {
      _cursorTimer?.cancel();
      if (!_hasCompleted) {
        _hasCompleted = true;
        widget.onCompleted?.call();
      }
      return;
    }

    const minDelay = 130;
    const maxDelay = 280;
    final delayMs = minDelay + _rand.nextInt(maxDelay - minDelay + 1);

    _charTimer?.cancel();
    _charTimer = Timer(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      setState(() {
        _visibleChars = (_visibleChars + 1)
            .clamp(0, widget.text.length)
            .toInt();
      });
      _scheduleNextChar();
    });
  }

  @override
  void dispose() {
    _charTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.text.substring(0, _visibleChars);
    final showCursor = _cursorOn && _visibleChars < widget.text.length;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: displayText),
          if (showCursor) const TextSpan(text: '_'),
        ],
      ),
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}
