import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/components/settings_item.dart';
import 'package:mobile/components/settings_section.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/providers/settings_notifier.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _scrollController = ScrollController();

  Future<void> _onPressedSignOutButton() async {
    await SecureStorageRepository().deleteToken();
    if (!mounted) return;
    context.go(RouterPaths.top);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.backgroundSummer),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 32.h, bottom: 20.h),
          width: 280.w,
          height: 531.h,
          decoration: BoxDecoration(
            color: AppColors.settingsBackground,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    width: 46.w,
                    height: 46.w,
                    margin: EdgeInsets.only(right: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.settingsCloseButtonBackground,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  trackVisibility: true,
                  thickness: 6.w,
                  radius: Radius.circular(40.r),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSection(
                            title: 'サウンド',
                            child: Column(
                              children: [
                                SettingsItem(
                                  title: 'BGM',
                                  switchValue: state.enableBGM,
                                  onSwitchChanged: notifier.setEnableBGM,
                                ),
                                SettingsItem(
                                  title: '効果音',
                                  switchValue: state.enableSE,
                                  onSwitchChanged: notifier.setEnableSE,
                                ),
                                SettingsItem(
                                  title: 'ボイス',
                                  switchValue: state.enableVoice,
                                  onSwitchChanged: notifier.setEnableVoice,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            height: 53.h,
                            child: ElevatedButton(
                              onPressed: _onPressedSignOutButton,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              child: const Text('ログアウト'),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
