import 'package:mobile/constants/display_options.dart';
import 'package:mobile/constants/image_paths.dart';

enum BackgroundOptions implements DisplayOption {
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

  @override
  String get name {
    switch (this) {
      case BackgroundOptions.spring:
        return '春';
      case BackgroundOptions.summer:
        return '夏';
      case BackgroundOptions.autumn:
        return '秋';
      case BackgroundOptions.winter:
        return '冬';
    }
  }
}
