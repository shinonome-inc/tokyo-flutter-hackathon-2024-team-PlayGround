import 'dart:math';

import 'package:mobile/constants/talk_scripts.dart';
import 'package:mobile/models/home_state.dart';
import 'package:mobile/providers/settings_notifier.dart';
import 'package:mobile/utils/text_speaker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return initialHomeState;
  }

  void setShowMenuSubButtons(bool showMenuSubButtons) {
    state = state.copyWith(showMenuSubButtons: showMenuSubButtons);
  }

  void setIsStartEatingAnimation(bool isStartEatingAnimation) {
    state = state.copyWith(isStartEatingAnimation: isStartEatingAnimation);
  }

  void setIsSpeaking(bool isSpeaking) {
    state = state.copyWith(isSpeaking: isSpeaking);
  }

  void toggleShowMenuSubButtons() {
    setShowMenuSubButtons(!state.showMenuSubButtons);
  }

  Future<void> speakRandomShortMessageByDash() async {
    if (state.isSpeaking) return;

    final enableVoice = ref.read(settingsNotifierProvider).enableVoice;
    if (!enableVoice) return;

    setIsSpeaking(true);
    final index = Random().nextInt(TalkScripts.shortMessages.length);
    final shortMessage = TalkScripts.shortMessages.elementAt(index);
    await TextSpeaker.instance.speakText(shortMessage);
    setIsSpeaking(false);
  }

  Future<void> giveFood() async {
    setIsSpeaking(true);
    setIsStartEatingAnimation(true);
    await TextSpeaker.instance.speakText(
      TalkScripts.eatingMessage,
      isAfterDelay: true,
    );
    setIsSpeaking(false);
    setIsStartEatingAnimation(false);
  }
}
