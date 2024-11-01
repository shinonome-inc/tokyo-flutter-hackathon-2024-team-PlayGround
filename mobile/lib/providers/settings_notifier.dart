import 'package:mobile/models/settings_state.dart';
import 'package:mobile/repositories/shared_preferences_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() {
    return _loadInitialSettingsStateFromLocalStorage();
  }

  SettingsState _loadInitialSettingsStateFromLocalStorage() {
    final enablePushNotification =
        SharedPreferencesRepository.instance.getEnablePushNotification();
    final enableBGM = SharedPreferencesRepository.instance.getEnableBGM();
    final enableSE = SharedPreferencesRepository.instance.getEnableSE();
    final enableVoice = SharedPreferencesRepository.instance.getEnableVoice();

    return initialSettingsState.copyWith(
      enablePushNotification: enablePushNotification,
      enableBGM: enableBGM,
      enableSE: enableSE,
      enableVoice: enableVoice,
    );
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> setEnablePushNotification(bool enable) async {
    state = state.copyWith(enablePushNotification: enable);
    await SharedPreferencesRepository.instance
        .setEnablePushNotification(enable);
  }

  Future<void> setEnableBGM(bool enable) async {
    state = state.copyWith(enableBGM: enable);
    await SharedPreferencesRepository.instance.setEnableBGM(enable);
  }

  Future<void> setEnableSE(bool enable) async {
    state = state.copyWith(enableSE: enable);
    await SharedPreferencesRepository.instance.setEnableSE(enable);
  }

  Future<void> setEnableVoice(bool enable) async {
    state = state.copyWith(enableVoice: enable);
    await SharedPreferencesRepository.instance.setEnableVoice(enable);
  }
}
