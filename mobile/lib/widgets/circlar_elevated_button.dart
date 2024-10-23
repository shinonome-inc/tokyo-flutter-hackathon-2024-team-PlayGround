import 'package:flutter/material.dart';

/// 円形のElevatedButton。
class CircularElevatedButton extends StatelessWidget {
  const CircularElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.diameter = 120.0,
  });

  final void Function()? onPressed;
  final Widget? child;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(diameter, diameter),
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
