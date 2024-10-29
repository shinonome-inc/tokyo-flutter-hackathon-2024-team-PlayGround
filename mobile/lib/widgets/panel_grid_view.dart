import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/background_options.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/constants/image_paths.dart';
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
  });

  final String title;
  final String subtitle;
  final Function? onSelected;
  final List<T> values;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: AppColors.dialogBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyles.title,
            ),
            const SizedBox(height: 28),
            Text(
              subtitle,
              style: TextStyles.subtitle,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(40),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 100 / 126,
                  ),
                  itemCount: DressUpOptions.values.length,
                  itemBuilder: (context, index) => SelectPanel(
                    title: 'title',
                    imagePath: ImagePaths.backgroundSummer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CustomTextButton(
                  text: 'キャンセル',
                  textColor: AppColors.darkGrey,
                  backgroundColor: AppColors.white,
                  onPressed: () => context.go(RouterPaths.home),
                ),
                SizedBox(width: 10),
                CustomTextButton(
                  text: '決定',
                  textColor: AppColors.white,
                  backgroundColor: AppColors.buttonBackground,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
