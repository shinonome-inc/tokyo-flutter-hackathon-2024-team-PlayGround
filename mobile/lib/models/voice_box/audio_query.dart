import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/models/voice_box/accent_phase.dart';

part 'audio_query.freezed.dart';
part 'audio_query.g.dart';

@freezed
class AudioQuery with _$AudioQuery {
  const factory AudioQuery({
    @JsonKey(name: 'accent_phrases') required List<AccentPhrase> accentPhrases,
    required double speedScale,
    required double pitchScale,
    required double intonationScale,
    required double volumeScale,
    required double prePhonemeLength,
    required double postPhonemeLength,
    double? pauseLength,
    double? pauseLengthScale,
    required int outputSamplingRate,
    required bool outputStereo,
    String? kana,
  }) = _AudioQuery;

  factory AudioQuery.fromJson(Map<String, dynamic> json) =>
      _$AudioQueryFromJson(json);
}
