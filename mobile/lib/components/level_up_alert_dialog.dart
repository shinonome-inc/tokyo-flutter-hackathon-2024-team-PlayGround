import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/constants/app_colors.dart';

/// レベルアップ時に表示するダイアログ。
///
/// arguments
/// [onTapClose]: 閉じるボタンを押した際に実行されるコールバック関数。
/// [newLevel]: レベルアップ後のレベル。2未満はArgumentErrorをスローする。
class LevelUpAlertDialog extends StatelessWidget {
  const LevelUpAlertDialog({
    super.key,
    required this.onTapClose,
    required this.newLevel,
  });

  final void Function()? onTapClose;
  final int newLevel;

  int get _previousLevel => newLevel - 1;

  @override
  Widget build(BuildContext context) {
    if (newLevel < 2) {
      throw ArgumentError('NewLevel must be greater than or equal to 2.');
    }
    const foregroundColor = Colors.white;
    const fontWeight = FontWeight.bold;
    final fontSize = 36.sp;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                color: AppColors.dialogBackground,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'レベルアップ!!',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Divider(
                      color: foregroundColor,
                      thickness: 2.h,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lv.$_previousLevel',
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '→',
                          style: TextStyle(
                            color: AppColors.dialogHighLight,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Lv.$newLevel',
                          style: TextStyle(
                            color: AppColors.dialogHighLight,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onTapClose,
                icon: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: foregroundColor,
                      width: 2.w,
                    ),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: Icon(
                    Icons.close,
                    color: foregroundColor,
                    size: 24.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
