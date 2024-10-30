import 'package:mobile/constants/display_option.dart';
import 'package:mobile/constants/image_paths.dart';

enum DressUpOptions implements DisplayOption {
  normal,
  spring,
  summer,
  autumn,
  winter;

  @override
  String get imagePath {
    switch (this) {
      case DressUpOptions.normal:
        return ImagePaths.dressNormal;
      case DressUpOptions.spring:
        return ImagePaths.dressSpring;
      case DressUpOptions.summer:
        return ImagePaths.dressSummer;
      case DressUpOptions.autumn:
        return ImagePaths.dressAutumn;
      case DressUpOptions.winter:
        return ImagePaths.dressWinter;
    }
  }

  @override
  String get name {
    switch (this) {
      case DressUpOptions.normal:
        return 'デフォルト';
      case DressUpOptions.spring:
        return '春';
      case DressUpOptions.summer:
        return '夏';
      case DressUpOptions.autumn:
        return '秋';
      case DressUpOptions.winter:
        return '冬';
    }
  }
}
