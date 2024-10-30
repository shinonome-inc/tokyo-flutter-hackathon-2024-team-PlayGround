import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/providers/dress_up_notifier.dart';
import 'package:mobile/widgets/panel_grid_view.dart';

class DressUpPage extends ConsumerWidget {
  const DressUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(dressUpNotifierProvider.notifier);
    final state = ref.watch(dressUpNotifierProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.go('/home');
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              ImagePaths.backgroundSummer,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Center(
              child: PanelGridView(
                title: 'きせかえ',
                subtitle: 'コーディネート一覧',
                onSelected: (DisplayOption value) {
                  notifier.setDressUp(value);
                },
                values: notifier.values,
                selectedValue: state,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
