import 'package:freezed_annotation/freezed_annotation.dart';

part 'dash.freezed.dart';

@freezed
class Dash with _$Dash {
  const factory Dash({
    required int level,
    required int currentExp,
    required int maxExp,
  }) = _Dash;
}

const initialDash = Dash(
  level: 1,
  currentExp: 0,
  maxExp: 1,
);
