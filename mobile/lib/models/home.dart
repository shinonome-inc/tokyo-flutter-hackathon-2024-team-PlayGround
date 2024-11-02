import 'package:freezed_annotation/freezed_annotation.dart';

part 'home.freezed.dart';
part 'home.g.dart';

@freezed
class Home with _$Home {
  const factory Home({
    required int feedCount,
    required String characterClothes,
    required String userName,
    required String avatarUrl,
    required String characterName,
    required int characterExperience,
    required String characterBackground,
    required int characterLevel,
  }) = _Home;

  factory Home.fromJson(Map<String, Object?> json) => _$HomeFromJson(json);
}
