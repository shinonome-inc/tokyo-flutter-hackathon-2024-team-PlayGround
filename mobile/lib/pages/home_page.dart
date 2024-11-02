import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/components/animated_images_view.dart';
import 'package:mobile/components/circlar_elevated_button.dart';
import 'package:mobile/components/level_progress_bar.dart';
import 'package:mobile/components/menu_sub_item_button.dart';
import 'package:mobile/constants/app_colors.dart';
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
          if (state.isStartEatingAnimation)
            Container(
              width: 200.w,
              margin: EdgeInsets.only(top: 80.h),
              child: AnimatedImagesView(
                isStart: state.isStartEatingAnimation,
                imagePathList: ImagePaths.foodWithEffects,
                intervalMilliseconds: 1200,
                delayedMilliseconds: 3500,
                isLoop: false,
                showOnlyPlaying: true,
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
                    SizedBox(
                      width: 100.0,
                      child: Column(
                        children: [
                          CircularElevatedButton(
                            onPressed: () async {
                              await notifier.giveFood();
                            },
                            backgroundColor:
                                AppColors.fetchFeedButtonBackground,
                            foregroundColor: AppColors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 40.0,
                                  child: Image.asset(
                                    ImagePaths.githubMark,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                const Text(
                                  'エサを補充',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          CircularElevatedButton(
                            onPressed: () async {
                              await notifier.giveFood();
                            },
                            backgroundColor: AppColors.giveFoodButtonBackground,
                            foregroundColor: AppColors.white,
                            child: const FittedBox(
                              child: Text(
                                'えさをあげる',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (state.showMenuSubButtons)
                            SizedBox(
                              width: 130.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  MenuSubItemButton(
                                    onPressed: () {
                                      context.push(RouterPaths.ranking);
                                    },
                                    icon: Image.asset(
                                      ImagePaths.menuSubItemRanking,
                                    ),
                                    text: 'ランキング',
                                    backgroundColor:
                                        AppColors.menuSubItemRankingBackground,
                                  ),
                                  MenuSubItemButton(
                                    onPressed: () {
                                      context.push(RouterPaths.makeover);
                                    },
                                    icon: Image.asset(
                                      ImagePaths.menuSubItemDressUp,
                                    ),
                                    text: 'きせかえ',
                                    backgroundColor:
                                        AppColors.menuSubItemDefaultBackground,
                                  ),
                                  MenuSubItemButton(
                                    onPressed: () {
                                      context.push(RouterPaths.makeover);
                                    },
                                    icon: Image.asset(
                                      ImagePaths.menuSubItemMakeover,
                                    ),
                                    text: '模様替え',
                                    backgroundColor:
                                        AppColors.menuSubItemDefaultBackground,
                                  ),
                                  MenuSubItemButton(
                                    onPressed: () {
                                      context.push(RouterPaths.settings);
                                    },
                                    icon: Image.asset(
                                      ImagePaths.menuSubItemSettings,
                                    ),
                                    text: '設定',
                                    backgroundColor:
                                        AppColors.menuSubItemSettingsBackground,
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                          SizedBox(
                            width: 100.0,
                            child: CircularElevatedButton(
                              onPressed: () {
                                notifier.toggleShowMenuSubButtons();
                              },
                              backgroundColor: AppColors.menuButtonBackground,
                              child: Image.asset(
                                ImagePaths.menuButtonIconAndText,
                              ),
                            ),
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
