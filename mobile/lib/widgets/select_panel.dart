import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/constants/text_styles.dart';

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
    print(type);
    print(type == DressUpOptions);
    return Column(
      children: [
        Text(
          title,
          style: TextStyles.subtitle,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Stack(
            children: [
              GestureDetector(
                onTap: onSelected,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.dialogItemBackground,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.all((type == DressUpOptions) ? 8.0 : 0),
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
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.buttonBackground,
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
