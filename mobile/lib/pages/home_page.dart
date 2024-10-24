import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/models/dash.dart';
import 'package:mobile/providers/home_notifier.dart';
import 'package:mobile/widgets/circlar_elevated_button.dart';
import 'package:mobile/widgets/level_prograss_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            ImagePaths.backgroundSummer,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Image.asset(
            ImagePaths.dash,
            width: 200,
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
            child: Column(
              children: [
                const SizedBox(height: 28.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 64.0),
                  // TODO: 仮のデータなので取得したデータに置き換える。
                  child: LevelProgressBar(dash: sampleDash),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CircularElevatedButton(
                        onPressed: () {},
                        child: const Text('エサをあげる'),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Column(
                        children: [
                          if (state.showMenuSubButtons)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    context.go(RouterPaths.ranking);
                                  },
                                  child: const Text('ランキング'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.go(RouterPaths.makeover);
                                  },
                                  child: const Text('模様替え'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.go(RouterPaths.dressUp);
                                  },
                                  child: const Text('着せ替え'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.go(RouterPaths.setting);
                                  },
                                  child: const Text('設定'),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          CircularElevatedButton(
                            onPressed: () {
                              notifier.toggleShowMenuSubButtons();
                            },
                            child: const Text('メニュー'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
