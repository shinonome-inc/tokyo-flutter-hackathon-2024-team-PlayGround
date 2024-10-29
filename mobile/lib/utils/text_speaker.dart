import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextSpeaker {
  TextSpeaker._() {
    _initialize();
  }

  static final TextSpeaker _instance = TextSpeaker._();

  factory TextSpeaker() {
    return _instance;
  }

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> _initialize() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setLanguage("jp-JP");
    final isAndroid = !kIsWeb && Platform.isAndroid;
    if (isAndroid) {
      await _flutterTts.getDefaultEngine;
      await _flutterTts.getDefaultVoice;
    }
  }

  static Future<void> speak(String text) async {
    print('speak: $text');
    if (text.isEmpty) return;
    await _instance._flutterTts.stop();
    await _instance._flutterTts.speak(text);
  }
}
