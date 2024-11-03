import 'dart:math';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mobile/constants/black_list_words.dart';
import 'package:mobile/constants/talk_scripts.dart';
import 'package:mobile/models/home.dart';
import 'package:mobile/models/home_state.dart';
import 'package:mobile/providers/settings_notifier.dart';
import 'package:mobile/services/gemini_client.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:mobile/utils/text_speaker.dart';
import 'package:mobile/utils/word_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part 'home_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  final _speech = stt.SpeechToText();

  bool get showUserSpeechText => state.userSpeechText.isNotEmpty;

  bool get showDashSpeechText => state.dashSpeechText.isNotEmpty;

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

  void setIsRecording(bool isRecording) {
    state = state.copyWith(isRecording: isRecording);
  }

  void setUserSpeechText(String userSpeechText) {
    state = state.copyWith(userSpeechText: userSpeechText);
  }

  void setIsStartEatingAnimation(bool isStartEatingAnimation) {
    state = state.copyWith(isStartEatingAnimation: isStartEatingAnimation);
  }

  void setIsSpeaking(bool isSpeaking) {
    state = state.copyWith(isSpeaking: isSpeaking);
  }

  void setDashSpeechText(String dashSpeechText) {
    state = state.copyWith(dashSpeechText: dashSpeechText);
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
    } catch (e) {
      print(e);
    } finally {
      setLoading(false);
    }

    setHome(home);
    print('fetched home: $home');
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

  Future<void> _speakAIGeneratedMessageByDash() async {
    if (state.isSpeaking) return;
    if (state.userSpeechText.isEmpty) return;

    setIsSpeaking(true);
    final containsPromptInjectionBlackListWords =
        WordChecker.instance.containsBlacklistWords(
      state.userSpeechText,
      BlackListWords.promptInjectionWords,
    );
    if (containsPromptInjectionBlackListWords) {
      const message = TalkScripts.promptInjectionWordMessage;
      setDashSpeechText(message);
      await TextSpeaker.instance.speakText(message);
      setIsSpeaking(false);
      return;
    }
    try {
      final generatedMessage = await GeminiClient.instance.generateDashMessage(
        inputText: state.userSpeechText,
      );
      setDashSpeechText(generatedMessage.replaceAll('\n', ''));
      await TextSpeaker.instance.speakText(state.dashSpeechText);
    } on GenerativeAIException {
      const message = TalkScripts.generativeAIExceptionMessage;
      setDashSpeechText(message);
      await TextSpeaker.instance.speakText(message);
    } catch (e) {
      const message = TalkScripts.exceptionMessage;
      setDashSpeechText(message);
      await TextSpeaker.instance.speakText(message);
    } finally {
      setIsSpeaking(false);
    }
  }

  Future<void> startRecording() async {
    if (state.isRecording) return;
    setIsRecording(true);
    setUserSpeechText('');
    setDashSpeechText('');
    final available = await _speech.initialize(
      onStatus: (status) async {
        if (status == 'notListening' && state.isRecording) {
          setIsRecording(false);
          await _speakAIGeneratedMessageByDash();
        }
      },
      onError: (error) {
        throw Exception('Failed to initialize speech to text: $error');
      },
    );
    if (available) {
      _speech.listen(
        pauseFor: const Duration(seconds: 3),
        onResult: (result) {
          final recognizedText = result.recognizedWords;
          setUserSpeechText(recognizedText);
        },
        localeId: 'ja-JP',
      );
    }
  }

  Future<void> stopRecording() async {
    if (!state.isRecording) return;
    await _speech.stop();
    setIsRecording(false);
    await _speakAIGeneratedMessageByDash();
  }

  void onCompletedRecording() {
    setIsRecording(false);
  }

  Future<int> fetchFeedCount() async {
    final feedCount = await RepositoriClient.instance.getFeedCount();
    state = state.copyWith(home: state.home?.copyWith(feedCount: feedCount));
    return feedCount;
  }
}
