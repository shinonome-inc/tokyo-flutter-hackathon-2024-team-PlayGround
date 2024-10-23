import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/repositories/api_client.dart'; // Retrofit APIクライアント
import 'package:dio/dio.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final clientId = dotenv.env['GITHUB_CLIENT_ID']!;
  final String redirectUri = 'http://localhost:3000/callback';
  late ApiClient _apiClient;
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(Dio()); // RetrofitのAPIクライアントを初期化
  }

  // GitHubの認証ページをWebViewで表示
  void _launchGitHubAuth() {
    final authorizationUrl =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=repo';
    _controller?.loadRequest(Uri.parse(authorizationUrl));
  }

  // 認証後にリダイレクトされたURLから認証コードを取得
  Future<void> handleAuthCallback(String code) async {
    try {
      final response = await _apiClient.getAccessToken(code);

      if (response.response.statusCode == 200) {
        final accessToken = response.data.access_token;

        // アクセストークンをセキュアストレージに保存
        await SecureStorageRepository().writeToken(accessToken);
        print('アクセストークンを保存しました: $accessToken');
      } else {
        print('アクセストークンの取得に失敗しました: ${response.response.statusMessage}');
      }
    } catch (e) {
      print('エラーが発生しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TopPage'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            await SecureStorageRepository().writeToken('test_token');
            context.go(RouterPaths.home);
          },
          child: const Text('GitHubでサインイン'),
        ),
      ),
    );
  }
}
