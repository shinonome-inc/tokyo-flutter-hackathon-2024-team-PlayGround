import 'package:mobile/models/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  final speech = stt.SpeechToText();

  @override
  HomeState build() {
    speechToText();
    ref.onDispose(
      () async {
        await speech.stop();
      },
    );
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

  void toggleShowMenuSubButtons() {
    setShowMenuSubButtons(!state.showMenuSubButtons);
  }

  Future<void> startRecording() async {
    setIsRecording(true);
  }

  Future<void> speechToText() async {
    setIsRecording(true);
    bool available = await speech.initialize(
      onStatus: (status) {
        print("status: $status");
        setIsRecording(false);
      },
      onError: (error) {
        print("error: $error");
      },
    );
    if (available) {
      speech.listen(
        onResult: (result) {
          print("result: $result");
          print("last word: ${result.recognizedWords}");
        },
        localeId: 'ja-JP',
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }
}
