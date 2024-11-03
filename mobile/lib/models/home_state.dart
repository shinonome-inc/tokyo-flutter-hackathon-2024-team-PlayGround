import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/models/home.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required bool isLoading,
    required Home? home,
    required bool showMenuSubButtons,
    required bool isStartEatingAnimation,
    required bool isSpeaking,
    required bool isRecording,
    required String userSpeechText,
    required String dashSpeechText,
    required bool isDelivering,
  }) = _HomeState;
}

const initialHomeState = HomeState(
  isLoading: false,
  home: null,
  showMenuSubButtons: false,
  isStartEatingAnimation: false,
  isSpeaking: false,
  isRecording: false,
  userSpeechText: '',
  dashSpeechText: '',
  isDelivering: false,
);
