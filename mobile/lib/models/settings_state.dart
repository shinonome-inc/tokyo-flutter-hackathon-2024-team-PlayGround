import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/constants/default_settings.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required bool isLoading,
    required bool enablePushNotification,
    required bool enableBGM,
    required bool enableSE,
    required bool enableVoice,
  }) = _SettingsState;
}

const initialSettingsState = SettingsState(
  isLoading: false,
  enablePushNotification: DefaultSettings.enablePushNotification,
  enableBGM: DefaultSettings.enableBGM,
  enableSE: DefaultSettings.enableSE,
  enableVoice: DefaultSettings.enableVoice,
);
