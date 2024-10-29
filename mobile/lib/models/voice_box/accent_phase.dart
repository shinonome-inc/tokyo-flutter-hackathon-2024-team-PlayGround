import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/models/voice_box/mora.dart';

part 'accent_phase.freezed.dart';
part 'accent_phase.g.dart';

@freezed
class AccentPhrase with _$AccentPhrase {
  const factory AccentPhrase({
    required List<Mora> moras,
    required double accent,
    @JsonKey(name: 'pause_mora') Mora? phaseMora,
    @JsonKey(name: 'is_interrogative') bool? isInterrogative,
  }) = _AccentPhrase;

  factory AccentPhrase.fromJson(Map<String, dynamic> json) =>
      _$AccentPhraseFromJson(json);
}
