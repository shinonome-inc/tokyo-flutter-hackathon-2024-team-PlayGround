import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/models/ranking.dart';

part 'ranking_state.freezed.dart';

@freezed
class RankingState with _$RankingState {
  const factory RankingState({
    required bool isLoading,
    required Ranking? ranking,
  }) = _RankingState;
}

const initialRankingState = RankingState(
  isLoading: false,
  ranking: null,
);
