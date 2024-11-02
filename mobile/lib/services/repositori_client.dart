import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/constants/makeover_options.dart';
import 'package:mobile/models/home.dart';
import 'package:mobile/models/home_state.dart';

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
    Response response = await _dio.put(
      '/change_clothes',
      data: {'item': dressUp.name},
    );
    if (response.statusCode == 200) {
      debugPrint('きせかえ成功${response.data}');
      return;
    }
    throw Exception('きせかえ失敗: ${response.statusCode}');
  }

  Future<void> putMakeover(MakeoverOptions makeover) async {
    Response response = await _dio.put(
      '/change_background',
      data: {'item': makeover.name},
    );
    if (response.statusCode == 200) {
      debugPrint('模様替え成功${response.data}');
      return;
    }
    throw Exception('模様替え失敗: ${response.statusCode}');
  }

  Future<Home> fetchHome() async {
    final response = await _dio.get('/home');

    if (response.statusCode == 200) {
      debugPrint('ホーム画面読み込み成功${response.data}');
      return Home.fromJson(response.data);
    }
    throw Exception('ホーム画面読み込み失敗: ${response.statusCode}');
  }
}
