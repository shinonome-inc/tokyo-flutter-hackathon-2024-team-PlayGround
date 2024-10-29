import 'package:flutter/material.dart';
import 'package:mobile/constants/text_styles.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.onPressed,
  });
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: TextStyles.subtitle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
