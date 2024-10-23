import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(Dio());

    // WebViewControllerのカスタマイズ
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // ページのURLがGitHubのリダイレクトURLになったとき認証コードを取得
            if (url.startsWith(redirectUri)) {
              final uri = Uri.parse(url);
              final code = uri.queryParameters['code'];
              if (code != null) {
                handleAuthCallback(code); // 認証コードを処理
              }
            }
          },
          onWebResourceError: (error) {
            print('WebView error: $error');
          },
        ),
      );
  }

  // サインインボタンを押したときにアクセストークンを確認
  Future<void> _signInWithGitHub() async {
    final accessToken = await SecureStorageRepository().readToken();
    if (accessToken != null) {
      // アクセストークンが存在する場合、そのまま次の画面へ遷移
      print('アクセストークンが存在しています: $accessToken');
      context.go(RouterPaths.home); // アクセストークンがあればホーム画面に遷移
    } else {
      print('アクセストークンが存在しません。認証を開始します。');
      _launchGitHubAuth(); // アクセストークンがなければ認証を開始
    }
  }

  // GitHubの認証ページをWebViewで表示
  void _launchGitHubAuth() {
    final authorizationUrl =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=repo';
    _controller.loadRequest(Uri.parse(authorizationUrl));
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

        if (mounted) {
          context.go(RouterPaths.home); // 認証成功時にホーム画面に遷移
        }
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
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: _controller)),
          ElevatedButton(
              onPressed: _signInWithGitHub,
              child: const Text('Sign in with GitHub')),
        ],
      ),
    );
  }
}
