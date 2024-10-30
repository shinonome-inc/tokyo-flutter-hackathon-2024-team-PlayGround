import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/constants/app_colors.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.title,
    required this.switchValue,
    required this.onSwitchChanged,
  });

  final String title;
  final bool switchValue;
  final void Function(bool)? onSwitchChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Switch(
          value: switchValue,
          activeTrackColor: AppColors.switchActiveTrack,
          onChanged: onSwitchChanged,
        ),
      ],
    );
  }
}
