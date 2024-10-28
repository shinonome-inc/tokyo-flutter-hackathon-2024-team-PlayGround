import 'package:flutter/material.dart';

class SelectPanel extends StatelessWidget {
  const SelectPanel({super.key, required this.title, required this.index});
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 8),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network('https://picsum.photos/200?image=$index'),
            ),
          ),
        ),
      ],
    );
  }
}
