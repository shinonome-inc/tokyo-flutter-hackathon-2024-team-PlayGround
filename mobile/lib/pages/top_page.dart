import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/api_client.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TopPage extends ConsumerStatefulWidget {
  const TopPage({super.key});

  @override
  ConsumerState createState() => _TopPageState();
}

class _TopPageState extends ConsumerState<TopPage> {
  final clientId = dotenv.env['GITHUB_CLIENT_ID']!;
  final baseUrl = dotenv.env['ENDPOINT']!;
  final String redirectUri = 'https://shinonome.com';
  late ApiClient _apiClient;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(Dio(), baseUrl: baseUrl);
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

  // GitHubの認証ページをWebViewで表示
  void _launchGitHubAuth() {
    final authorizationUrl =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=repo,read:org,read:user,user:email';
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
              onPressed: _launchGitHubAuth,
              child: const Text('Sign in with GitHub')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(RouterPaths.home);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
