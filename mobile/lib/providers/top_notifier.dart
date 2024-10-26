import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<bool> isSignedIn() async {
    if (state.isLoading) return false;
    setLoading(true);

    final accessToken = await SecureStorageRepository().readToken();
    if (accessToken == null) {
      return false;
    }

    try {
      await GithubService().fetchUser();
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }

    return true;
  }

  Future<void> signIn(String url) async {
    if (state.isLoading) return;
    setLoading(true);

    final redirectUri = dotenv.env['GITHUB_REDIRECT_URL'];
    if (redirectUri == null || !url.startsWith(redirectUri)) {
      return;
    }

    // ページのURLがリダイレクトURLになったとき認証コードを取得
    final uri = Uri.parse(url);
    final code = uri.queryParameters['code'];
    if (code == null) return;

    // コードを使用してアクセストークンを取得
    final notifier = ref.read(topNotifierProvider.notifier);
    try {
      await notifier.fetchAccessToken(code);
    } catch (e) {
      return;
    }
  }

  /// アクセストークンを取得する。
  Future<void> fetchAccessToken(String code) async {
    if (state.isLoading) return;
    setLoading(true);
    try {
      final token = await GithubService().fetchAccessToken(code);
      await SecureStorageRepository().writeToken(token);
    } catch (e) {
      debugPrint('Failed to fetch access token: $e');
    } finally {
      setLoading(false);
    }
  }
}
