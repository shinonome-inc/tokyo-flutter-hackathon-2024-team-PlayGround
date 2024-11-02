import 'package:flutter/material.dart';
import 'package:mobile/models/launch_state.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
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

  void setOpacity(double opacity) {
    state = state.copyWith(opacity: opacity);
  }

  Future<bool> isSignedIn() async {
    final token = await SecureStorageRepository().readToken();
    // TODO: アクセストークンが有効かどうかGitHubのAPIを叩いて確認する。
    // TODO: ユーザーを取得する。

    // NOTE: 現在はアクセストークンがローカルに保存されているかどうかで判定している。
    // NOTE: API通信の待機時間を再現するために擬似的に待機している。
    await Future.delayed(Durations.extralong4);
    setOpacity(1.0);
    await Future.delayed(const Duration(seconds: 3));

    return token != null;
  }
}
