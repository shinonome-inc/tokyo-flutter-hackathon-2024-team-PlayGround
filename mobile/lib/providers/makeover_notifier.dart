import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/makeover_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makeover_notifier.g.dart';

@riverpod
class MakeoverNotifier extends _$MakeoverNotifier {
  @override
  MakeoverOptions build() {
    return MakeoverOptions.spring;
  }

  void setDressUp(DisplayOption dressUp) {
    state = dressUp as MakeoverOptions;
  }

  get values => MakeoverOptions.values;
}
