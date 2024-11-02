import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/constants/app_colors.dart';

class MenuSubItemButton extends StatelessWidget {
  const MenuSubItemButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.backgroundColor,
  });

  final void Function()? onPressed;
  final Widget icon;
  final String text;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.0,
            child: icon,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
