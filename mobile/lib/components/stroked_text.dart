import 'package:flutter/material.dart';

/// ストロークのTextを表示するWidgetです。
class StrokedText extends StatelessWidget {
  const StrokedText(
    this.text, {
    super.key,
    required this.textColor,
    required this.strokeColor,
    this.strokeWidth = 6,
    required this.style,
  });

  final String text;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: style.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
