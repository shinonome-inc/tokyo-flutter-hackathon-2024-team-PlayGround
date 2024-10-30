import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/providers/makeover_notifier.dart';
import 'package:mobile/widgets/panel_grid_view.dart';

class MakeoverPage extends ConsumerWidget {
  const MakeoverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(makeoverNotifierProvider.notifier);
    final state = ref.watch(makeoverNotifierProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.go(RouterPaths.home);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              state.imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Center(
              child: PanelGridView(
                title: '模様替え',
                subtitle: '背景一覧',
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
