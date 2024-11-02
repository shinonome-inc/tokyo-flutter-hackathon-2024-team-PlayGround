import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/constants/dress_up_options.dart';

class RepositoriClient {
  RepositoriClient._() {
    final baseUrl = dotenv.env['ENDPOINT'] ?? '';
    final accessToken = dotenv.env['ACCESS_TOKEN'] ?? '';
    debugPrint(accessToken);
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Authorization'] = accessToken;
    //ログを沢山吐かせるやつ
    _dio.interceptors.add(LogInterceptor());
  }

  final Dio _dio = Dio();

  static final RepositoriClient instance = RepositoriClient._();

  Future<void> putDressUp(DressUpOptions dressUp) async {
    try {
      Response response = await _dio.put(
        '/change_clothes',
        data: {'item': dressUp.name},
      );

      if (response.statusCode == 200) {
        debugPrint('きせかえ成功${response.data}');
      } else {
        debugPrint('きせかえ失敗: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('きせかえ失敗:$e');
    }
  }
}
