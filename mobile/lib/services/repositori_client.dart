import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RepositoriClient {
  RepositoriClient._() {
    final baseUrl = dotenv.env['ENDPOINT'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('ENDPOINT is not defined.');
    }
    _dio.options.baseUrl = baseUrl;
    //ログを沢山吐かせるやつ
    _dio.interceptors.add(LogInterceptor());
  }

  final Dio _dio = Dio();

  static final RepositoriClient instance = RepositoriClient._();

  void setToken(String token) {
    print('set token: $token');
    _dio.options.headers['Authorization'] = token;
  }

  /// 認証コードを使ってアクセストークンを取得する。
  ///
  /// [code] リダイレクトURLから取得した認証コード。
  Future<String> fetchAccessToken(String code) async {
    print('code: $code');
    final response = await _dio.get(
      '/token',
      queryParameters: {'code': code},
    );
    print('fetch access token with status code ${response.statusCode}');
    if (response.statusCode == 200) {
      final token = response.data['access_token'];
      setToken(token);
      return token;
    } else {
      throw Exception(
        'Failed to fetch access token with status code ${response.statusCode}',
      );
    }
  }

  Future<int> getFeedCount() async {
    final response = await _dio.post('/get_feed');
    if (response.statusCode == 200) {
      debugPrint('えさ取得成功${response.data}');
      return response.data['feedCount'] ?? 0;
    }
    throw Exception('えさ取得失敗: ${response.statusCode}');
  }
}
