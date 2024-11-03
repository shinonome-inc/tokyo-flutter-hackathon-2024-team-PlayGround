import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/stroked_text.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';

/// ダッシュちゃんの現在のレベルと経験値を表示します。
class LevelProgressBar extends StatelessWidget {
  const LevelProgressBar({
    super.key,
    required this.level,
    required this.currentExp,
    required this.maxExp,
  });

  final int level;
  final int currentExp;
  final int maxExp;

  final _strokeWidth = 1.8;
  final _fontWeight = FontWeight.w500;

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
              Align(
                alignment: Alignment.centerLeft,
                child: StrokedText(
                  'Lv.$level',
                  textColor: AppColors.white,
                  strokeColor: AppColors.levelProgressBarOutline,
                  strokeWidth: _strokeWidth,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: _fontWeight,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                color: AppColors.white,
                child: LinearProgressIndicator(
                  value: currentExp / maxExp,
                  backgroundColor: AppColors.levelProgressBarOutline,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.levelProgressBarMain,
                  ),
                  minHeight: 20.h,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: StrokedText(
                  '$currentExp / $maxExp',
                  textColor: AppColors.white,
                  strokeColor: AppColors.levelProgressBarOutline,
                  strokeWidth: _strokeWidth,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: _fontWeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
