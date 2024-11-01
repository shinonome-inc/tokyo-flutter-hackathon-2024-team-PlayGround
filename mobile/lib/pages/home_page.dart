import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/components/chat_bubble.dart';
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
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      if (notifier.showUserSpeechText)
                        ChatBubble(
                          message: state.userSpeechText,
                          tip: ChatBubbleTip.left,
                        )
                      else if (notifier.showDashSpeechText)
                        ChatBubble(
                          message: state.dashSpeechText,
                          tip: ChatBubbleTip.bottom,
                        ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await notifier.speakRandomShortMessageByDash();
                  },
                  child: Image.asset(
                    ImagePaths.dash,
                    width: 200.0,
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
              child: Column(
                children: [
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
                        child: Column(
                          children: [
                            CircularElevatedButton(
                              onPressed: state.isRecording
                                  ? notifier.stopRecording
                                  : notifier.startRecording,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(state.isRecording
                                      ? Icons.stop
                                      : Icons.mic),
                                  Text(state.isRecording ? 'ストップ' : 'はなしかける'),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            CircularElevatedButton(
                              onPressed: () {},
                              child: const Text('エサをあげる'),
                            ),
                          ],
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
          ),
        ],
      ),
    );
  }
}
