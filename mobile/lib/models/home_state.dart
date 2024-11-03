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
    required bool isDelivering,
  }) = _HomeState;
}

const initialHomeState = HomeState(
  isLoading: false,
  home: Home(
    userName: "userName",
    avatarUrl: "avatarUrl",
    characterName: "characterName",
    characterLevel: 0,
    characterExperience: 0,
    characterClothes: 'characterClothes',
    characterBackground: "characterBackground",
    feedCount: 0,
  ),
  showMenuSubButtons: false,
  isStartEatingAnimation: false,
  isSpeaking: false,
  isDelivering: false,
);
