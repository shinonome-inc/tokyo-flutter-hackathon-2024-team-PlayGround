import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/constants/makeover_options.dart';
import 'package:mobile/models/home.dart';

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

  Future<Home> fetchHome() async {
    print('home token');
    print(_dio.options.headers['Authorization']);
    final response = await _dio.get(
      '/home',
      options: Options(
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ),
    );

    if (response.statusCode == 200) {
      return Home.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to fetch home with status code ${response.statusCode}',
      );
    }
  }

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

  Future<void> putMakeover(MakeoverOptions makeover) async {
    try {
      Response response = await _dio.put(
        '/change_background',
        data: {'item': makeover.name},
      );

      if (response.statusCode == 200) {
        debugPrint('模様替え成功${response.data}');
      } else {
        debugPrint('模様替え失敗: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('模様替え失敗:$e');
    }
  }
}
