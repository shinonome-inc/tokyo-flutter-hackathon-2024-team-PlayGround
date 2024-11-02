import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_user.freezed.dart';
part 'ranking_user.g.dart';

@freezed
class RankingUser with _$RankingUser {
  const factory RankingUser({
    required String userName,
    required String avatarUrl,
    required String characterName,
    required int characterLevel,
    required String characterClothes,
    required String characterBackground,
  }) = _RankingUser;

  factory RankingUser.fromJson(Map<String, Object?> json) =>
      _$RankingUserFromJson(json);
}
