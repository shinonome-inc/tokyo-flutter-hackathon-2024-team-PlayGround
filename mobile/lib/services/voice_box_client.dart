import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/models/voice_box/audio_query.dart';

class VoiceBoxClient {
  VoiceBoxClient._() {
    final baseUrl = dotenv.env['VOICE_BOX_API_BASE_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('VOICE_BOX_API_BASE_URL is not defined.');
    }
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  final Dio _dio = Dio();

  static final VoiceBoxClient instance = VoiceBoxClient._();

  Future<Uint8List> fetchVoiceData(String text) async {
    final response = await _dio.post(
      '',
      data: {
        'text': text,
      },
      options: Options(
        responseType: ResponseType.bytes, // バイナリデータとして受け取る
      ),
    );
    if (response.statusCode == 200) {
      try {
        final bytes = Uint8List.fromList(response.data);
        return bytes;
      } catch (e) {
        print('cast error: $e');
      }
    }
    throw Exception(
      'Failed to fetch voice. Status code: ${response.statusCode}',
    );
  }

  /// 音声クエリを作成する。
  Future<AudioQuery> createQuery({
    required String text,
    speaker = 1,
  }) async {
    _dio.interceptors.add(LogInterceptor());
    final response = await _dio.post(
      '/',
    );

    if (response.statusCode == 200) {
      print('response: ${response.data}');
      return AudioQuery.fromJson(response.data);
    }
    throw Exception(
      'Failed to create query. Status code: ${response.statusCode}',
    );
  }

  // 音声データを作成する。
  Future<Uint8List> createVoice({
    required AudioQuery query,
    speaker = 1,
  }) async {
    final response = await _dio.post(
      '/synthesis',
      data: jsonEncode(query),
      queryParameters: {
        'speaker': speaker,
      },
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    if (response.statusCode == 200) {
      return Uint8List.fromList(response.data);
    }
    throw Exception(
      'Failed to create voice. Status code: ${response.statusCode}',
    );
  }
}
