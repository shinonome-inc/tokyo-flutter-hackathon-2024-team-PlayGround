import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GithubService {
  final Dio _dio;

  GithubService({Dio? dio}) : _dio = dio ?? Dio();

  final baseUrl = dotenv.env['GITHUB_API_BASE_URL'];
  final tokenRequestUrl = dotenv.env['GITHUB_TOKEN_REQUEST_URL'];

  /// アクセストークンを取得する。
  Future<String?> fetchAccessToken(String code) async {
    if (tokenRequestUrl == null) {
      throw Exception('GitHub Token request URL is not set.');
    }

    final response = await _dio.post(
      tokenRequestUrl!,
      queryParameters: {
        'code': code,
        'client_id': dotenv.env['GITHUB_CLIENT_ID'],
        'client_secret': dotenv.env['GITHUB_CLIENT_SECRET'],
      },
    );
    if (response.statusCode == 200) {
      final queryParams = Uri.splitQueryString(response.data);
      final accessToken = queryParams['access_token'];
      _dio.options.headers['Authorization'] = 'token $accessToken';
      return accessToken;
    } else {
      throw Exception(
        'Failed to fetch access token. Status code: ${response.statusCode}, message: ${response.statusMessage}',
      );
    }
  }

  /// ユーザー情報を取得する。
  Future<void> fetchUser() async {
    final response = await _dio.get('$baseUrl/user');
    if (response.statusCode == 200) {
      // TODO: ユーザーを取得する。
      print(response.data);
    } else {
      throw Exception(
        'Failed to fetch user. Status code: ${response.statusCode}, message: ${response.statusMessage}',
      );
    }
  }
}
