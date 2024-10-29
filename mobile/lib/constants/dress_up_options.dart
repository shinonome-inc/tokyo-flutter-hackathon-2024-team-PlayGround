import 'package:mobile/constants/image_options.dart';
import 'package:mobile/constants/image_paths.dart';

enum DressUpOptions implements ImageOptions {
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
}
