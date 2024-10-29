import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required bool showMenuSubButtons,
    required bool isRecording,
    required String userSpeechText,
  }) = _HomeState;
}

const initialHomeState = HomeState(
  showMenuSubButtons: false,
  isRecording: false,
  userSpeechText: '',
);
