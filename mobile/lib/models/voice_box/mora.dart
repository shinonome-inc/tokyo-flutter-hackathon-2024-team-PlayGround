import 'package:freezed_annotation/freezed_annotation.dart';

part 'mora.freezed.dart';
part 'mora.g.dart';

@freezed
class Mora with _$Mora {
  const factory Mora({
    required String text,
    String? consonant,
    @JsonKey(name: 'consonant_length') double? consonantLength,
    required String vowel,
    @JsonKey(name: 'vowel_length') required double vowelLength,
    required double pitch,
  }) = _Mora;

  factory Mora.fromJson(Map<String, dynamic> json) => _$MoraFromJson(json);
}
