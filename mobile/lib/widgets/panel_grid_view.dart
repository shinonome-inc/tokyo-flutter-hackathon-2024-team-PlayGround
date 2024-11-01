import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/router_paths.dart';
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
  });

  final String title;
  final String subtitle;
  final void Function(DisplayOption) onSelected;
  final List<DisplayOption> values;
  final DisplayOption selectedValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 661.h,
      width: 300.w,
      decoration: BoxDecoration(
        color: AppColors.dialogBackground,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20).w,
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
            ),
            SizedBox(height: 28.h),
            Text(
              subtitle,
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 6.h,
                radius: Radius.circular(40.r),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 100 / 126,
                    ),
                    itemCount: values.length,
                    itemBuilder: (context, index) {
                      final value = values[index];
                      return SelectPanel(
                        title: value.name,
                        imagePath: value.imagePath,
                        onSelected: () => onSelected(value),
                        isSelected: value == selectedValue,
                        type: value.runtimeType,
                      );
                    }),
              ),
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
                const CustomTextButton(
                  text: '決定',
                  textColor: AppColors.white,
                  backgroundColor: AppColors.primaryGold,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
