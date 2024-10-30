import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

class SelectPanel<T> extends StatelessWidget {
  const SelectPanel({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onSelected,
    this.isSelected = false,
    required this.fit,
  });
  final String title;
  final String imagePath;
  final VoidCallback onSelected;
  final bool isSelected;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 8),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: onSelected,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.dialogItemBackground,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.buttonBackground
                        : AppColors.dialogItemBackground,
                    width: 4,
                  ),
                ),
                child: Image.asset(imagePath, fit: fit),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
