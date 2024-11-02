import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/image_paths.dart';

enum MakeoverOptions implements DisplayOption {
  spring,
  summer,
  autumn,
  winter;

  @override
  String get imagePath {
    switch (this) {
      case MakeoverOptions.spring:
        return ImagePaths.backgroundSpring;
      case MakeoverOptions.summer:
        return ImagePaths.backgroundSummer;
      case MakeoverOptions.autumn:
        return ImagePaths.backgroundAutumn;
      case MakeoverOptions.winter:
        return ImagePaths.backgroundWinter;
    }
  }

  @override
  String get jpName {
    switch (this) {
      case MakeoverOptions.spring:
        return '春';
      case MakeoverOptions.summer:
        return '夏';
      case MakeoverOptions.autumn:
        return '秋';
      case MakeoverOptions.winter:
        return '冬';
    }
  }
}
