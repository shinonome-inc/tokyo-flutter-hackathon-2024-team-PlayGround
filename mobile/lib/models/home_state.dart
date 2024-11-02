import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';
part 'home_state.g.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool showMenuSubButtons,
    @Default(false) bool isStartEatingAnimation,
    @Default(false) bool isSpeaking,
    required int feedCount,
    required String characterClothes,
    required String userName,
    required String avatarUrl,
    required String characterName,
    required int characterExperience,
    required String characterBackground,
    required int characterLevel,
  }) = _HomeState;
  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);
}

const initialHomeState = HomeState(
  showMenuSubButtons: false,
  isStartEatingAnimation: false,
  isSpeaking: false,
  feedCount: 7,
  characterClothes: "normal",
  userName: "DASH",

  //TODO: picsumから変更する
  avatarUrl: "https://picsum.photos/200/200",
  characterName: "DASH",
  characterExperience: 0,
  characterBackground: "normal",
  characterLevel: 1,
);
