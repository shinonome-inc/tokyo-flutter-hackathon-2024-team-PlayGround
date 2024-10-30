import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required bool showMenuSubButtons,
    required bool isStartEatingAnimation,
    required bool isSpeaking,
  }) = _HomeState;
}

const initialHomeState = HomeState(
  showMenuSubButtons: false,
  isStartEatingAnimation: false,
  isSpeaking: false,
);
