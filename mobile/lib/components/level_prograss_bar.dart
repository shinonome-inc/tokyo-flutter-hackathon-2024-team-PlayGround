import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/models/dash.dart';

/// ダッシュちゃんの現在のレベルと経験値を表示します。
class LevelProgressBar extends StatelessWidget {
  const LevelProgressBar({super.key, required this.dash});

  final Dash dash;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.favorite,
          color: Colors.red,
          size: 48.w,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            children: [
              Text(
                'Lv.${dash.level}',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              LinearProgressIndicator(
                value: dash.currentExp / dash.maxExp,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 20.h,
              ),
              Text(
                '${dash.currentExp}/${dash.maxExp}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
