import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/stroked_text.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/models/dash.dart';

/// ダッシュちゃんの現在のレベルと経験値を表示します。
class LevelProgressBar extends StatelessWidget {
  const LevelProgressBar({super.key, required this.dash});

  final Dash dash;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48.0,
          child: Image.asset(ImagePaths.levelProgressBarHeart),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            children: [
              StrokedText(
                'Lv.${dash.level}',
                textColor: AppColors.white,
                strokeColor: AppColors.levelProgressBarOutline,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                color: AppColors.white,
                child: LinearProgressIndicator(
                  value: dash.currentExp / dash.maxExp,
                  backgroundColor: AppColors.levelProgressBarOutline,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.levelProgressBarMain,
                  ),
                  minHeight: 20.h,
                ),
              ),
              StrokedText(
                '${dash.currentExp} / ${dash.maxExp}',
                textColor: AppColors.white,
                strokeColor: AppColors.levelProgressBarOutline,
                style: const TextStyle(
                  fontSize: 20.0,
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
