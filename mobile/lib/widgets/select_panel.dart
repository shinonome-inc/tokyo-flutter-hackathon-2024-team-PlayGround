import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

class SelectPanel extends StatelessWidget {
  const SelectPanel({
    super.key,
    required this.title,
    required this.imagePath,
  });
  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 8),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.dialogItemBackground,
                border: Border.all(
                  color: AppColors.buttonBackground,
                  width: 4,
                ),
              ),
              child: Image.asset(imagePath),
            ),
          ),
        ),
      ],
    );
  }
}
