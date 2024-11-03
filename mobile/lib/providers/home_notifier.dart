import 'dart:math';

import 'package:mobile/constants/talk_scripts.dart';
import 'package:mobile/models/home.dart';
import 'package:mobile/models/home_state.dart';
import 'package:mobile/providers/settings_notifier.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:mobile/utils/text_speaker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return initialHomeState;
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setHome(Home? home) {
    state = state.copyWith(home: home);
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

  void setIsDelivering(bool isDelivering) {
    state = state.copyWith(isDelivering: isDelivering);
  }

  void setFeedCount(int feedCount) {
    state = state.copyWith(home: state.home?.copyWith(feedCount: feedCount));
    print('state: ${state}');
  }

  Future<void> fetchHome() async {
    if (state.isLoading) return;

    setLoading(true);
    Home? home;
    try {
      home = await RepositoriClient.instance.fetchHome();
      print('1$home');
    } catch (e) {
      print(e);
    } finally {
      setLoading(false);
    }
    print('2$home');
    setHome(home);
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
    // fetchHome();
    await TextSpeaker.instance.speakText(
      TalkScripts.eatingMessage,
      isAfterDelay: true,
    );
    setIsSpeaking(false);
    setIsStartEatingAnimation(false);
  }

  Future<int> fetchFeedCount() async {
    final feedCount = await RepositoriClient.instance.getFeedCount();
    state = state.copyWith(home: state.home?.copyWith(feedCount: feedCount));
    return feedCount;
  }
}
