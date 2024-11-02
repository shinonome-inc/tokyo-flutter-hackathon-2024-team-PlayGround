import 'package:flutter/material.dart';

/// 円形のElevatedButton。
class CircularElevatedButton extends StatelessWidget {
  const CircularElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.diameter,
    this.backgroundColor,
    this.foregroundColor,
  });

  final void Function()? onPressed;
  final Widget? child;
  final double? diameter;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final size = Size.fromWidth(diameter ?? 120.0);
    return SizedBox(
      width: size.width,
      height: size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
