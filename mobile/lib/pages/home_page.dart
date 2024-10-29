import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/components/circlar_elevated_button.dart';
import 'package:mobile/components/level_prograss_bar.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/models/dash.dart';
import 'package:mobile/providers/home_notifier.dart';

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
          GestureDetector(
            onTap: () async {
              await notifier.speakRandomShortMessageByDash();
            },
            child: Image.asset(
              ImagePaths.dash,
              width: 200.w,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
            child: Column(
              children: [
                SizedBox(height: 28.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 64.w),
                  // TODO: 仮のデータなので取得したデータに置き換える。
                  child: const LevelProgressBar(dash: sampleDash),
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
                                SizedBox(height: 16.h),
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
