import 'dart:math';

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
import 'package:mobile/models/food_options.dart';
import 'package:mobile/providers/dress_up_notifier.dart';
import 'package:mobile/providers/feed_count_notifier.dart';
import 'package:mobile/providers/food_notifier.dart';
import 'package:mobile/providers/home_notifier.dart';
import 'package:mobile/providers/makeover_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);
    final dressUpState = ref.read(dressUpNotifierProvider);
    final makeoverState = ref.read(makeoverNotifierProvider);
    final foodState = ref.read(foodNotifierProvider);
    final feedCountNotifier = ref.read(feedCountNotifierProvider.notifier);
    return GestureDetector(
      onTap: () {
        if (state.showMenuSubButtons) {
          notifier.setShowMenuSubButtons(false);
        }
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              makeoverState.imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            GestureDetector(
              onTap: () async {
                await notifier.speakRandomShortMessageByDash();
              },
              child: Image.asset(
                dressUpState.imagePath,
                width: 200.w,
              ),
            ),
            if (state.isStartEatingAnimation)
              Container(
                width: 200.w,
                margin: EdgeInsets.only(top: 80.h),
                child: AnimatedImagesView(
                  isStart: state.isStartEatingAnimation,
                  imagePathList: foodState.imagePaths,
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
                    child: LevelProgressBar(
                      level: state.home?.characterLevel ?? 1,
                      currentExp: state.home?.characterExperience ?? 0,
                      maxExp:
                          (10 * pow(2, ((state.home?.characterLevel ?? 5) + 1)))
                              .toInt(),
                    ),
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
                                notifier.setIsDelivering(true);
                                final feedCount =
                                    await notifier.fetchFeedCount();
                                notifier.setIsDelivering(false);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'えさを補充しました！ 現在${state.home?.feedCount}個'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                                print(feedCount);
                              },
                              backgroundColor:
                                  AppColors.fetchFeedButtonBackground,
                              foregroundColor: AppColors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 32.0,
                                    child: Image.asset(
                                      ImagePaths.githubMark,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  const Text(
                                    'えさを\n補充',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            CircularElevatedButton(
                              onPressed: () {
                                context.push(RouterPaths.food);
                              },
                              backgroundColor:
                                  AppColors.giveFoodButtonBackground,
                              foregroundColor: AppColors.white,
                              child: const Text(
                                'えさを\nあげる',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    MenuSubItemButton(
                                      onPressed: () {
                                        context.push(RouterPaths.ranking);
                                      },
                                      icon: Image.asset(
                                        ImagePaths.menuSubItemRanking,
                                      ),
                                      text: 'ランキング',
                                      backgroundColor: AppColors
                                          .menuSubItemRankingBackground,
                                    ),
                                    MenuSubItemButton(
                                      onPressed: () {
                                        context.push(RouterPaths.dressUp);
                                      },
                                      icon: Image.asset(
                                        ImagePaths.menuSubItemDressUp,
                                      ),
                                      text: 'きせかえ',
                                      backgroundColor: AppColors
                                          .menuSubItemDefaultBackground,
                                    ),
                                    MenuSubItemButton(
                                      onPressed: () {
                                        context.push(RouterPaths.makeover);
                                      },
                                      icon: Image.asset(
                                        ImagePaths.menuSubItemMakeover,
                                      ),
                                      text: '模様替え',
                                      backgroundColor: AppColors
                                          .menuSubItemDefaultBackground,
                                    ),
                                    MenuSubItemButton(
                                      onPressed: () {
                                        context.push(RouterPaths.settings);
                                      },
                                      icon: Image.asset(
                                        ImagePaths.menuSubItemSettings,
                                      ),
                                      text: '設定',
                                      backgroundColor: AppColors
                                          .menuSubItemSettingsBackground,
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
            Visibility(
              visible: state.isDelivering,
              child: Image.asset(
                ImagePaths.haitatsu,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
