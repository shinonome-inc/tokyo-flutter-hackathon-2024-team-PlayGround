import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/dress_up_options.dart';

class SelectPanel<T> extends StatelessWidget {
  const SelectPanel({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onSelected,
    required this.type,
    this.isSelected = false,
  });
  final String title;
  final String imagePath;
  final VoidCallback onSelected;
  final bool isSelected;
  final T type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onTap: onSelected,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.dialogBackground,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.all((type == DressUpOptions) ? 8.0 : 0)
                                .w,
                        child: Image.asset(
                          imagePath,
                          fit: (type == DressUpOptions)
                              ? BoxFit.contain
                              : BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.primaryGold,
                        width: 4,
                      ),
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
