import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/constants/makeover_options.dart';

class SelectPanel extends StatelessWidget {
  const SelectPanel({
    super.key,
    required this.onSelected,
    this.isSelected = false,
    required this.values,
    required this.index,
    required this.selectedValue,
  });
  final Function(DisplayOption) onSelected;
  final bool isSelected;
  final List<DisplayOption> values;
  final int index;
  final DisplayOption selectedValue;

  @override
  Widget build(BuildContext context) {
    final title = values[index].name;
    final imagePath = values[index].imagePath;
    final isSelected = selectedValue == values[index];
    final type = selectedValue.runtimeType;
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          constraints: BoxConstraints(
            maxWidth: 120.w,
            maxHeight: 120.h,
          ),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => onSelected(values[index]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.menuItemBackground,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.all((type == MakeoverOptions) ? 0 : 8.0)
                                .w,
                        child: Image.asset(
                          imagePath,
                          fit: (type == MakeoverOptions)
                              ? BoxFit.cover
                              : BoxFit.contain,
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
