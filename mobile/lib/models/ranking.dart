import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/models/ranking_user.dart';

part 'ranking.freezed.dart';
part 'ranking.g.dart';

@freezed
class Ranking with _$Ranking {
  const factory Ranking({
    required List<RankingUser> rankings,
  }) = _Ranking;

  factory Ranking.fromJson(Map<String, Object?> json) =>
      _$RankingFromJson(json);
}
