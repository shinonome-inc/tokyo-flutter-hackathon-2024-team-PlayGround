import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/image_paths.dart';

enum FoodOptions implements DisplayOption {
  ramen,
  curry,
  mapoTofu,
  tteokbokki;

  @override
  String get imagePath {
    switch (this) {
      case FoodOptions.ramen:
        return ImagePaths.foodRamen;
      case FoodOptions.curry:
        return ImagePaths.foodCurry;
      case FoodOptions.mapoTofu:
        return ImagePaths.foodMapoTofu;
      case FoodOptions.tteokbokki:
        return ImagePaths.foodTteokbokki;
    }
  }

  @override
  String get name {
    switch (this) {
      case FoodOptions.ramen:
        return 'ラーメン';
      case FoodOptions.curry:
        return 'カレー';
      case FoodOptions.mapoTofu:
        return '麻婆豆腐';
      case FoodOptions.tteokbokki:
        return 'トッポッキ';
    }
  }
}

extension FoodOptionsExtension on FoodOptions {
  List<String> get imagePaths {
    switch (this) {
      case FoodOptions.ramen:
        return ImagePaths.ramenWithEffects;
      case FoodOptions.curry:
        return ImagePaths.curryWithEffects;
      case FoodOptions.mapoTofu:
        return ImagePaths.mapoTofuWithEffects;
      case FoodOptions.tteokbokki:
        return ImagePaths.tteokbokkiWithEffects;
    }
  }
}
