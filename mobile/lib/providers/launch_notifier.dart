import 'package:flutter/cupertino.dart';
import 'package:mobile/models/launch_state.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/services/github_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'launch_notifier.g.dart';

@riverpod
class LaunchNotifier extends _$LaunchNotifier {
  @override
  LaunchState build() {
    return initialLaunchState;
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
