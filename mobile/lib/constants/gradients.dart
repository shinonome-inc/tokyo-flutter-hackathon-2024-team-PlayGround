import 'package:flutter/material.dart';

class Gradients {
  Gradients._();

  static const _begin = Alignment.topLeft;
  static const _end = Alignment.bottomRight;
  static final _stops = [0.4, 0.8, 1.0];

  static final Gradient gold = LinearGradient(
    begin: _begin,
    end: _end,
    stops: _stops,
    colors: const [
      Color(0xFFD0A900),
      Color(0xFFFFF9E6),
      Color(0xFFD0A900),
    ],
  );

  static final Gradient silver = LinearGradient(
    begin: _begin,
    end: _end,
    colors: const [
      Color(0xFFABACAC),
      Color(0xFFF5F6F6),
      Color(0xFFABACAC),
    ],
    stops: _stops,
  );

  static final Gradient bronze = LinearGradient(
    begin: _begin,
    end: _end,
    colors: const [
      Color(0xFFAC6831),
      Color(0xFFEDB677),
      Color(0xFFAC6831),
    ],
    stops: _stops,
  );
}
