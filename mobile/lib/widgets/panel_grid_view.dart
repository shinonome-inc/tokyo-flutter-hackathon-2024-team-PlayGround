import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/constants/text_styles.dart';
import 'package:mobile/widgets/custom_text_button.dart';
import 'package:mobile/widgets/select_panel.dart';

class PanelGridView<T> extends StatelessWidget {
  const PanelGridView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onSelected,
    required this.values,
    required this.selectedValue,
    required this.onConfirm,
    this.foodCount,
    this.confirtText = '決定',
  });

  final String title;
  final String subtitle;
  final void Function(DisplayOption) onSelected;
  final List<DisplayOption> values;
  final DisplayOption selectedValue;
  final Function onConfirm;
  final int? foodCount;
  final String confirtText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: AppColors.menuBackground,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20).w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyles.gridViewheadingLarge,
            ),
            SizedBox(height: 16.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: subtitle,
                    style: TextStyles.gridViewheadingSmall.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  if (foodCount != null)
                    TextSpan(
                      text: ' $foodCount',
                      style: TextStyles.gridViewheadingSmall.copyWith(
                        color: AppColors.foodCountRed,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // SizedBox(height: 16.h),
            // Expanded(
            //   child: GridView.builder(
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2,
            //         crossAxisSpacing: 10,
            //         mainAxisSpacing: 10,
            //         childAspectRatio: 100 / 126,
            //       ),
            //       itemCount: values.length,
            //       itemBuilder: (context, index) {
            //         final value = values[index];
            //         return SelectPanel(
            //           title: value.name,
            //           imagePath: value.imagePath,
            //           onSelected: () => onSelected(value),
            //           isSelected: value == selectedValue,
            //           type: value.runtimeType,
            //         );
            //       }),
            // ),
            if (values.length > 4)
              Column(
                children: [
                  SelectPanel(
                    values: values,
                    selectedValue: selectedValue,
                    onSelected: onSelected,
                    index: 4,
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            Row(
              children: [
                SelectPanel(
                  values: values,
                  selectedValue: selectedValue,
                  onSelected: onSelected,
                  index: 0,
                ),
                const Spacer(),
                SelectPanel(
                  values: values,
                  selectedValue: selectedValue,
                  onSelected: onSelected,
                  index: 1,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SelectPanel(
                  values: values,
                  selectedValue: selectedValue,
                  onSelected: onSelected,
                  index: 2,
                ),
                const Spacer(),
                SelectPanel(
                  values: values,
                  selectedValue: selectedValue,
                  onSelected: onSelected,
                  index: 3,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                CustomTextButton(
                  text: 'キャンセル',
                  textColor: AppColors.darkGrey,
                  backgroundColor: AppColors.white,
                  onPressed: () => context.go(RouterPaths.home),
                ),
                SizedBox(width: 10.w),
                CustomTextButton(
                  text: confirtText,
                  textColor: AppColors.white,
                  backgroundColor: AppColors.primaryGold,
                  onPressed: () => onConfirm(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
