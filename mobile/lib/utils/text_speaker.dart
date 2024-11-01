import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mobile/services/voice_box_client.dart';
import 'package:mobile/utils/file_converter.dart';
import 'package:universal_html/html.dart' as html;

/// テキストの音声読み上げを行う。
class TextSpeaker {
  TextSpeaker._() {
    _initializeFlutterTts();
  }

  static final instance = TextSpeaker._();

  final _flutterTts = FlutterTts();
  final _audioPlayer = AudioPlayer();

  Future<void> _initializeFlutterTts() async {
    await _flutterTts.setLanguage('ja-JP');
    await _flutterTts.setVolume(1.0);
  }

  Future<void> _speakTextWithFlutterTts(String text) async {
    await _flutterTts.pause();
    await _flutterTts.speak(text);
  }

  Future<void> _speakTextWithVoiceBox(String text, bool isAfterDelay) async {
    final query = await VoiceBoxClient.instance.createQuery(text: text);
    final bytes = await VoiceBoxClient.instance.createVoice(query: query);
    if (kIsWeb) {
      final base64String = base64Encode(bytes);
      final audio = html.AudioElement()
        ..src = 'data:audio/wav;base64,$base64String'
        ..autoplay = true;
      await audio.play();
      return;
    }
    final file = await FileConverter.convertBytesToWavFile(bytes);
    await _audioPlayer.play(DeviceFileSource(file.path));
    if (!isAfterDelay) {
      return;
    }
    final duration = await _audioPlayer.getDuration() ?? Duration.zero;
    await Future.delayed(duration);
  }

  /// テキストの音声読み上げを行う。
  ///
  /// .envのUSE_VOICE_BOXがtrueの場合はVoiceBoxを、
  /// falseの場合はFlutterTtsを使用して音声読み上げを行う。
  ///
  /// [text] 読み上げるテキスト
  ///
  /// [isAfterDelay] 音声読み上げ後に遅延させるかどうか。音声の長さ分だけ遅延を行う。
  Future<void> speakText(
    String text, {
    bool isAfterDelay = false,
  }) async {
    final bool useVoiceBox = bool.parse(dotenv.env['USE_VOICE_BOX'] ?? 'false');
    if (useVoiceBox) {
      await _speakTextWithVoiceBox(text, isAfterDelay);
    } else {
      await _speakTextWithFlutterTts(text);
    }
  }
}
