import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

class InteractiveQuote extends StatefulWidget {
  const InteractiveQuote({
    super.key,
    required this.text,
    required this.style,
    this.hoverScale = 1.2,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle style;
  final double hoverScale;
  final TextAlign textAlign;

  @override
  State<InteractiveQuote> createState() => _InteractiveQuoteState();
}

class _InteractiveQuoteState extends State<InteractiveQuote> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final characters = widget.text.characters.toList();
    final letterSpacing = widget.style.letterSpacing ?? 0;
    final spaceWidth = (widget.style.fontSize ?? 16) * 0.35 + letterSpacing;

    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        children: [
          for (int i = 0; i < characters.length; i++)
            characters[i] == ' '
                ? WidgetSpan(
                    child: SizedBox(width: spaceWidth),
                  )
                : WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: MouseRegion(
                      onEnter: (_) => setState(() => _hoveredIndex = i),
                      onExit: (_) => setState(() => _hoveredIndex = null),
                      child: AnimatedScale(
                        scale: _hoveredIndex == i ? widget.hoverScale : 1.0,
                        duration: const Duration(milliseconds: 140),
                        curve: Curves.easeOut,
                        child: Text(
                          characters[i],
                          style: _hoveredIndex == i
                              ? widget.style.copyWith(
                                  color: AppColors.primaryLight,
                                )
                              : widget.style,
                        ),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
