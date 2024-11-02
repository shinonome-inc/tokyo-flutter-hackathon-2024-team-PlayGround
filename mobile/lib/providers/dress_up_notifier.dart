import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/repositories/shared_preferences_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dress_up_notifier.g.dart';

@riverpod
class DressUpNotifier extends _$DressUpNotifier {
  @override
  DressUpOptions build() {
    return _loadInitialDressUpFromLocalStorage();
  }

  DressUpOptions _loadInitialDressUpFromLocalStorage() {
    return SharedPreferencesRepository.instance.getDressUp();
  }

  void setDressUp(DisplayOption dressUp) {
    state = dressUp as DressUpOptions;
  }

  Future<void> storeDressUp() async {
    await SharedPreferencesRepository.instance.setDressUp(state);
  }

  get values => DressUpOptions.values;
}
