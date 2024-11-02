import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/constants/talk_scripts.dart';
import 'package:mobile/models/home_state.dart';
import 'package:mobile/providers/dress_up_notifier.dart';
import 'package:mobile/providers/makeover_notifier.dart';
import 'package:mobile/providers/settings_notifier.dart';
import 'package:mobile/services/repositori_client.dart';
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

  Future<bool> getHomeState(WidgetRef ref) async {
    try {
      state = await RepositoriClient.instance.fetchHome();
      ref
          .read(makeoverNotifierProvider.notifier)
          .setMakeoverByString(state.characterBackground);
      ref
          .read(dressUpNotifierProvider.notifier)
          .setDressUpByString(state.characterClothes);
      return true;
    } catch (e) {
      return false;
    }
  }
}
