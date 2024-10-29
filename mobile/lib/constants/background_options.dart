import 'package:mobile/constants/image_options.dart';
import 'package:mobile/constants/image_paths.dart';

enum BackgroundOptions implements ImageOptions {
  spring,
  summer,
  autumn,
  winter;

  @override
  String get imagePath {
    switch (this) {
      case BackgroundOptions.spring:
        return ImagePaths.dressSpring;
      case BackgroundOptions.summer:
        return ImagePaths.dressSummer;
      case BackgroundOptions.autumn:
        return ImagePaths.dressAutumn;
      case BackgroundOptions.winter:
        return ImagePaths.dressWinter;
    }
  }
}
