import 'package:dio/dio.dart';

class GitHubClient {
  GitHubClient._() {
    const baseUrl = 'https://api.github.com';
    _dio.options.baseUrl = baseUrl;
  }

  final Dio _dio = Dio();

  static final GitHubClient instance = GitHubClient._();

  /// アクセストークンが有効かどうか確認する。
  Future<bool> isTokenValid(String token) async {
    _dio.options.headers['Authorization'] = 'token $token';
    Response<dynamic> response;
    try {
      response = await _dio.get('/user');
    } catch (e) {
      print(e);
      return false;
    } finally {
      _dio.options.headers.remove('Authorization');
    }
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
