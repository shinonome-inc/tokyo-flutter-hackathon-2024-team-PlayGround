import 'package:mobile/constants/default_settings.dart';
import 'package:mobile/constants/prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  static final instance = SharedPreferencesRepository._();

  late final SharedPreferences _prefs;

  SharedPreferencesRepository._();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setEnablePushNotification(bool enable) async {
    await _prefs.setBool(PrefsKeys.enablePushNotification, enable);
  }

  Future<void> setEnableBGM(bool enable) async {
    await _prefs.setBool(PrefsKeys.enableBGM, enable);
  }

  Future<void> setEnableSE(bool enable) async {
    await _prefs.setBool(PrefsKeys.enableSE, enable);
  }

  Future<void> setEnableVoice(bool enable) async {
    await _prefs.setBool(PrefsKeys.enableVoice, enable);
  }

  bool getEnablePushNotification() {
    return _prefs.getBool(PrefsKeys.enablePushNotification) ??
        DefaultSettings.enablePushNotification;
  }

  bool getEnableBGM() {
    return _prefs.getBool(PrefsKeys.enableBGM) ?? DefaultSettings.enableBGM;
  }

  bool getEnableSE() {
    return _prefs.getBool(PrefsKeys.enableSE) ?? DefaultSettings.enableSE;
  }

  bool getEnableVoice() {
    return _prefs.getBool(PrefsKeys.enableVoice) ?? DefaultSettings.enableVoice;
  }
}
