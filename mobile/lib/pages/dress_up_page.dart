import 'package:flutter/material.dart';
import 'package:mobile/widgets/panel_grid_view.dart';

class DressUpPage extends StatelessWidget {
  const DressUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DressUpPage'),
      ),
      body: const Center(
        child: PanelGridView(
          title: 'きせかえ',
          subtitle: 'コーディネート一覧',
        ),
      ),
    );
  }
}
