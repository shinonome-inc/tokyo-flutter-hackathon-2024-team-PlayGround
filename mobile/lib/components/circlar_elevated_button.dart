import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 円形のElevatedButton。
class CircularElevatedButton extends StatelessWidget {
  const CircularElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.diameter,
  });

  final void Function()? onPressed;
  final Widget? child;
  final double? diameter;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromWidth(diameter ?? 120.w),
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
