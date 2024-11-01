import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/repositories/api_client.dart';
import 'package:dio/dio.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  late ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    final baseUrl = dotenv.env['ENDPOINT']!;
    _apiClient = ApiClient(Dio(), baseUrl: baseUrl);
    _handleAuthCallback();
  }

  Future<void> _handleAuthCallback() async {
    final uri = Uri.base;
    final code = uri.queryParameters['code'];
    if (code != null) {
      // 認証コードを処理
      await _processAuthCode(code);
    } else {
      // エラーハンドリング
      print('認証コードが見つかりませんでした。');
    }
  }

  Future<void> _processAuthCode(String code) async {
    try {
      final response = await _apiClient.getAccessToken(code);

      if (response.response.statusCode == 200) {
        final accessToken = response.data.access_token;

        // アクセストークンをセキュアストレージに保存
        await SecureStorageRepository().writeToken(accessToken);
        print('アクセストークンを保存しました: $accessToken');

        if (mounted) {
          context.go(RouterPaths.home); // 認証成功時にホーム画面に遷移
        }
      } else {
        print('アクセストークンの取得に失敗しました: ${response.response.statusMessage}');
        // 必要に応じてエラーメッセージを表示するか、再試行します。
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      // 必要に応じてエラーハンドリングを行います。
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('認証中...'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
