import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/providers/food_notifier.dart';
import 'package:mobile/providers/home_notifier.dart';
import 'package:mobile/widgets/panel_grid_view.dart';

class FoodPage extends ConsumerWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(foodNotifierProvider.notifier);
    final state = ref.watch(foodNotifierProvider);
    final homeNotifier = ref.read(homeNotifierProvider.notifier);
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
              ImagePaths.backgroundSummer,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Center(
              child: PanelGridView(
                title: 'えさを選ぶ',
                subtitle: 'えさの数',
                onSelected: (DisplayOption value) {
                  notifier.setFood(value);
                },
                onConfirm: () async {
                  await notifier.storeFood();
                  if (context.mounted) {
                    context.go(RouterPaths.home);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await homeNotifier.giveFood();
                  });
                },
                values: notifier.values,
                selectedValue: state,
                foodCount: 5,
                confirtText: 'あげる',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
