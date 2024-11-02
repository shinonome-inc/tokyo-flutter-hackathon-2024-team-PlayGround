import 'package:freezed_annotation/freezed_annotation.dart';

part 'home.freezed.dart';
part 'home.g.dart';

@freezed
class Home with _$Home {
  const factory Home({
    required String userName,
    required String avatarUrl,
    required String characterName,
    required int characterLevel,
    required int characterExperience,
    required String characterClothes,
    required String characterBackground,
    required int feedCount,
  }) = _Home;

  factory Home.fromJson(Map<String, Object?> json) => _$HomeFromJson(json);
}
