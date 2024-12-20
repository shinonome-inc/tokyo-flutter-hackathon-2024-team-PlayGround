import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/models/feed.dart';
import 'package:mobile/constants/dress_up_options.dart';
import 'package:mobile/constants/makeover_options.dart';
import 'package:mobile/models/home.dart';
import 'package:mobile/models/ranking.dart';
import 'package:mobile/models/ranking_user.dart';

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

  Future<Ranking> fetchRanking() async {
    final response = await _dio.get(
      '/ranking',
      options: Options(
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
      final rankings = jsonData
          .map((item) => RankingUser.fromJson(item as Map<String, dynamic>))
          .toList();
      return Ranking(rankings: rankings);
    } else {
      throw Exception(
        'Failed to fetch ranking with status code ${response.statusCode}',
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

  Future<int> getFeedCount() async {
    final response = await _dio.post('/get_feed');
    if (response.statusCode == 200) {
      debugPrint('えさ取得成功${response.data}');
      return response.data['feedCount'] ?? 0;
    }
    throw Exception('えさ取得失敗: ${response.statusCode}');
  }

  Future<Feed> postFeed() async {
    final response = await _dio.post('/feed');
    if (response.statusCode == 200) {
      debugPrint('えさやり成功${response.data}');
      return Feed.fromJson(response.data);
    }
    throw Exception('えさやり失敗: ${response.statusCode}');
  }
}
