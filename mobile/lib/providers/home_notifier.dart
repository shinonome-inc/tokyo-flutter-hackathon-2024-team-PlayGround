import 'dart:async';
import 'dart:math';

import 'package:mobile/constants/talk_scripts.dart';
import 'package:mobile/models/home_state.dart';
import 'package:mobile/utils/text_speaker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  Timer? _stopRecordingTimer;

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

  void toggleShowMenuSubButtons() {
    setShowMenuSubButtons(!state.showMenuSubButtons);
  }

  Future<void> startRecording() async {
    setIsRecording(true);
    _startRecordingTimer();
  }

  Future<void> speechToText() async {
    final speech = stt.SpeechToText();
    setIsRecording(true);
    final available = await speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setIsRecording(false);
          _stopRecordingTimer?.cancel();
        }
      },
      onError: (error) {
        throw Exception('Failed to initialize speech to text: $error');
      },
    );
    if (available) {
      speech.listen(
        onResult: (result) {
          final recognizedText = result.recognizedWords;
          setUserSpeechText(recognizedText);
          _resetRecordingTimer();
        },
        localeId: 'ja-JP',
      );
    }
  }

  Future<void> speakRandomShortMessageByDash() async {
    if (state.isSpeaking) {
      return;
    }
    setIsSpeaking(true);
    final index = Random().nextInt(TalkScripts.shortMessages.length);
    final shortMessage = TalkScripts.shortMessages.elementAt(index);
    await TextSpeaker.instance.speakText(shortMessage);
    setIsSpeaking(false);
  }

  void _startRecordingTimer() {
    _stopRecordingTimer = Timer(const Duration(seconds: 3), () {
      setIsRecording(false);
    });
  }

  void _resetRecordingTimer() {
    _stopRecordingTimer?.cancel();
    _startRecordingTimer();
  }
}
