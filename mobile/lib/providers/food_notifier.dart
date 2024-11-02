import 'package:mobile/constants/display_option.dart';
import 'package:mobile/models/food_options.dart';
import 'package:mobile/repositories/shared_preferences_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_notifier.g.dart';

@riverpod
class FoodNotifier extends _$FoodNotifier {
  @override
  FoodOptions build() {
    return _loadInitialFoodFromLocalStorage();
  }

  FoodOptions _loadInitialFoodFromLocalStorage() {
    return SharedPreferencesRepository.instance.getFood();
  }

  void setFood(DisplayOption food) {
    state = food as FoodOptions;
  }

  Future<void> storeFood() async {
    await SharedPreferencesRepository.instance.setFood(state);
  }

  get values => FoodOptions.values;
}
