import 'dart:async';
import 'dart:math';

import 'package:mobile/constants/talk_scripts.dart';
import 'package:mobile/models/home_state.dart';
import 'package:mobile/services/gemini_client.dart';
import 'package:mobile/utils/text_speaker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  final _speech = stt.SpeechToText();

  bool get showUserSpeechText =>
      state.userSpeechText.isNotEmpty && !showDashSpeechText;

  bool get showDashSpeechText => state.dashSpeechText.isNotEmpty;

  @override
  HomeState build() {
    return initialHomeState;
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

  void setIsSpeaking(bool isSpeaking) {
    state = state.copyWith(isSpeaking: isSpeaking);
  }

  void setDashSpeechText(String dashSpeechText) {
    state = state.copyWith(dashSpeechText: dashSpeechText);
  }

  void toggleShowMenuSubButtons() {
    setShowMenuSubButtons(!state.showMenuSubButtons);
  }

  Future<void> speakRandomShortMessageByDash() async {
    if (state.isSpeaking) return;

    setIsSpeaking(true);
    final index = Random().nextInt(TalkScripts.shortMessages.length);
    final shortMessage = TalkScripts.shortMessages.elementAt(index);
    await TextSpeaker.instance.speakText(shortMessage);
    setIsSpeaking(false);
  }

  Future<void> _speakAIGeneratedMessageByDash() async {
    if (state.isSpeaking) return;
    if (state.userSpeechText.isEmpty) return;

    setIsSpeaking(true);
    final generatedMessage = await GeminiClient.instance.generateDashMessage(
      inputText: state.userSpeechText,
    );
    setDashSpeechText(generatedMessage);
    await TextSpeaker.instance.speakText(generatedMessage);
    setIsSpeaking(false);
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
}
