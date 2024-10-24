import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/services/api_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final clientId = dotenv.env['GITHUB_CLIENT_ID']!;
  final String redirectUri = 'https://shinonome.com';
  late ApiClient _apiClient;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(Dio());
    _controller = WebViewController();

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

  // アクセストークンの有効性を確認
  Future<void> _signInWithGitHub() async {
    final accessToken = await SecureStorageRepository().readToken();
    if (accessToken != null) {
      print('アクセストークンが存在しています: $accessToken');
      final isValid = await _isTokenValid(accessToken);

      if (isValid) {
        // トークンが有効ならそのまま次の画面に遷移
        context.go(RouterPaths.home);
      } else {
        // トークンが無効または期限切れなら再認証
        print('アクセストークンが期限切れです。再認証を行います。');
        _launchGitHubAuth();
      }
    } else {
      print('アクセストークンが存在しません。認証を開始します。');
      _launchGitHubAuth(); // アクセストークンがなければ認証を開始
    }
  }

  // GitHubアクセストークンが有効かどうかを確認
  Future<bool> _isTokenValid(String accessToken) async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'token $accessToken';

      // GitHub APIのユーザー情報取得エンドポイントを使用してトークンの有効性を確認
      final response = await dio.get('https://api.github.com/user');

      if (response.statusCode == 200) {
        return true; // トークンが有効
      } else {
        return false; // トークンが無効または期限切れ
      }
    } catch (e) {
      print('エラーチェック中: $e');
      return false; // エラーが発生した場合もトークンが無効と見なす
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
        final accessToken = response.data.accessToken;

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
