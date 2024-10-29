import 'package:flutter/material.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/widgets/panel_grid_view.dart';

class MakeoverPage extends StatelessWidget {
  const MakeoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MakeoverPage'),
      ),
      body: Stack(
        children: [
          Image.asset(
            ImagePaths.backgroundSummer,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const Center(
            child: PanelGridView(
              title: '模様替え',
              subtitle: '背景一覧',
            ),
          ),
        ],
      ),
    );
  }
}
