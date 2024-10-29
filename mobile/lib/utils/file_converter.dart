import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// ファイル変換に関するユーティリティクラス。
class FileConverter {
  FileConverter._();

  /// バイトデータを音声ファイル（wav形式）に変換する。
  static Future<File> convertBytesToWavFile(Uint8List bytes) async {
    final tempDirectory = await getTemporaryDirectory();
    final file = File('${tempDirectory.path}/audio.wav');
    await file.writeAsBytes(bytes);
    return file;
  }
}
