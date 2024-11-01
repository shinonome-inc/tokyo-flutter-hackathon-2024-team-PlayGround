import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required bool showMenuSubButtons,
    required bool isSpeaking,
    required bool isRecording,
    required String userSpeechText,
    required String dashSpeechText,
  }) = _HomeState;
}

const initialHomeState = HomeState(
  showMenuSubButtons: false,
  isSpeaking: false,
  isRecording: false,
  userSpeechText: '',
  dashSpeechText: '',
);
