import 'package:flutter/material.dart';
import 'package:mobile/models/launchstate.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/services/git_hub_client.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'launch_notifier.g.dart';

@riverpod
class LaunchNotifier extends $LaunchNotifier {
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
    bool isSignedIn = false;
    final token = await SecureStorageRepository().readToken();

    if (token != null) {
      final isTokenValid = await GitHubClient.instance.isTokenValid(token);
      isSignedIn = isTokenValid;
    }

    print('is signed in: $isSignedIn');
    if (isSignedIn && token != null) {
      RepositoriClient.instance.setToken(token);
      print('set token: $token');
    }

    await Future.delayed(Durations.extralong4);
    setOpacity(1.0);
    await Future.delayed(const Duration(seconds: 3));

    return isSignedIn;
  }
}
