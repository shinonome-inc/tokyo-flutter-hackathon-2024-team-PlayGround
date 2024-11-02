import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/makeover_options.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makeover_notifier.g.dart';

@riverpod
class MakeoverNotifier extends _$MakeoverNotifier {
  @override
  MakeoverOptions build() {
    return MakeoverOptions.summer;
  }

  void setMakeover(DisplayOption makeover) {
    state = makeover as MakeoverOptions;
  }

  void setMakeoverByString(String makeover) {
    state = MakeoverOptions.values.byName(makeover);
  }

  Future<void> storeMakeover() async {
    await RepositoriClient.instance.putMakeover(state);
  }

  get values => MakeoverOptions.values;
}
