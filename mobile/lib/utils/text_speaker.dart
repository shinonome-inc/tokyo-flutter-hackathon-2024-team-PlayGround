import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mobile/services/voice_box_client.dart';
import 'package:mobile/utils/file_converter.dart';

/// テキストの音声読み上げを行う。
class TextSpeaker {
  TextSpeaker._();

  static final TextSpeaker _instance = TextSpeaker._();

  factory TextSpeaker() {
    return _instance;
  }

  Future<void> _speakTextWithFlutterTts(String text) async {
    final flutterTts = FlutterTts();
    await flutterTts.setLanguage('ja-JP');
    await flutterTts.speak(text);
  }

  Future<void> _speakTextWithVoiceBox(String text) async {
    final query = await VoiceBoxClient.instance.createQuery(text: text);
    final bytes = await VoiceBoxClient.instance.createVoice(query: query);
    final file = await FileConverter.convertBytesToWavFile(bytes);
    final player = AudioPlayer();
    await player.play(DeviceFileSource(file.path));
  }

  /// テキストの音声読み上げを行う。
  ///
  /// .envのUSE_VOICE_BOXがtrueの場合はVoiceBoxを、
  /// falseの場合はFlutterTtsを使用して音声読み上げを行う。
  ///
  /// [text] 読み上げるテキスト
  Future<void> speakText(String text) async {
    final bool useVoiceBox = bool.parse(dotenv.env['USE_VOICE_BOX'] ?? 'false');
    if (useVoiceBox) {
      await _speakTextWithVoiceBox(text);
    } else {
      await _speakTextWithFlutterTts(text);
    }
  }
}
