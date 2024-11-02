import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/makeover_options.dart';
import 'package:mobile/repositories/shared_preferences_repository.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makeover_notifier.g.dart';

@riverpod
class MakeoverNotifier extends _$MakeoverNotifier {
  @override
  MakeoverOptions build() {
    return _loadInitialMakeoverFromLocalStorage();
  }

  MakeoverOptions _loadInitialMakeoverFromLocalStorage() {
    return SharedPreferencesRepository.instance.getMakeover();
  }

  void setMakeover(DisplayOption makeover) {
    state = makeover as MakeoverOptions;
  }

  Future<void> storeMakeover() async {
    await RepositoriClient.instance.putMakeover(state);
    await SharedPreferencesRepository.instance.setMakeover(state);
  }

  get values => MakeoverOptions.values;
}
