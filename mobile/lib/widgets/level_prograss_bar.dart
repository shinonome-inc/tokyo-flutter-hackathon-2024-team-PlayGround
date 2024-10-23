import 'package:flutter/material.dart';
import 'package:mobile/models/dash.dart';

/// ダッシュちゃんの現在のレベルと経験値を表示します。
class LevelProgressBar extends StatelessWidget {
  const LevelProgressBar({super.key, required this.dash});

  final Dash dash;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 48.0,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            children: [
              Text(
                'Lv.${dash.level}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              LinearProgressIndicator(
                value: dash.currentExp / dash.maxExp,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 20.0,
              ),
              Text(
                '${dash.currentExp}/${dash.maxExp}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
