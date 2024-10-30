import 'package:mobile/constants/display_options.dart';
import 'package:mobile/constants/dress_up_options.dart';
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

  get values => DressUpOptions.values;
}
