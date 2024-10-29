import 'package:flutter/material.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/widgets/panel_grid_view.dart';

class DressUpPage extends StatelessWidget {
  const DressUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DressUpPage'),
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
              title: 'きせかえ',
              subtitle: 'コーディネート一覧',
              onSelected: null,
              values: DressUpOptions.values,
            ),
          ),
        ],
      ),
    );
  }
}
