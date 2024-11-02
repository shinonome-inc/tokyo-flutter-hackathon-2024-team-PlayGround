import 'package:mobile/models/ranking.dart';
import 'package:mobile/models/ranking_state.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_notifier.g.dart';

@riverpod
class RankingNotifier extends _$RankingNotifier {
  @override
  RankingState build() {
    return initialRankingState;
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setRanking(Ranking? ranking) {
    state = state.copyWith(ranking: ranking);
  }

  Future<void> fetchRanking() async {
    if (state.isLoading) return;

    setLoading(true);
    Ranking? ranking = await RepositoriClient.instance.fetchRanking();
    try {
      ranking = await RepositoriClient.instance.fetchRanking();
    } catch (e) {
      print(e);
    } finally {
      setLoading(false);
    }
    setRanking(ranking);
  }
}
