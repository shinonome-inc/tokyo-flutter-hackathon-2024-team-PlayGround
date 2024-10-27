import 'package:mobile/models/top_state.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/services/github_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'top_notifier.g.dart';

@riverpod
class TopNotifier extends _$TopNotifier {
  @override
  TopState build() {
    return initialTopState;
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> signInByRedirectUrl(String redirectUrl) async {
    if (state.isLoading) return;
    setLoading(true);

    final uri = Uri.parse(redirectUrl);
    final code = uri.queryParameters['code'];
    if (code == null) {
      throw Exception('Failed to get code from URL: $redirectUrl');
    }

    final token = await _fetchAccessToken(code);
    await SecureStorageRepository().writeToken(token);
    setLoading(false);
  }

  /// アクセストークンを取得する。
  Future<String?> _fetchAccessToken(String code) async {
    try {
      final token = await GitHubService().fetchAccessToken(code);
      return token;
    } catch (e) {
      throw Exception('Failed to fetch access token: $e');
    }
  }
}
