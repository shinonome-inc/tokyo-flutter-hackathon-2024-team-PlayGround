import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dress_up_notifier.g.dart';

@riverpod
class DressUpNotifier extends _$DressUpNotifier {
  @override
  DressUpOptions build() {
    return DressUpOptions.normal;
  }

  void setDressUp(DisplayOption dressUp) {
    state = dressUp as DressUpOptions;
  }

  Future<void> storeDressUp() async {
    await RepositoriClient.instance.putDressUp(state);
  }

  void setDressUpByString(String dressUp) {
    state = DressUpOptions.values.byName(dressUp);
  }

  get values => DressUpOptions.values;
}
