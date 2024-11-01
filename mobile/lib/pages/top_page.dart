import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final clientId = dotenv.env['GITHUB_CLIENT_ID']!;
  final baseUrl = dotenv.env['ENDPOINT']!;
  final String redirectUri =
      'https://d11feo1e8byiei.cloudfront.net/auth-callback';

  @override
  void initState() {
    super.initState();
  }

  // アクセストークンの有効性を確認
  Future<void> _signInWithGitHub() async {
    final accessToken = await SecureStorageRepository().readToken();
    if (accessToken != null) {
      print('アクセストークンが存在しています: $accessToken');
      final isValid = await _isTokenValid(accessToken);

      if (isValid) {
        // トークンが有効ならそのまま次の画面に遷移
        if (mounted) {
          context.go(RouterPaths.home);
        }
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

  // GitHubの認証ページをブラウザで開く
  void _launchGitHubAuth() async {
    final authorizationUrl =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=repo,read:org,read:user,user:email';
    if (await canLaunchUrl(Uri.parse(authorizationUrl))) {
      await launchUrl(Uri.parse(authorizationUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $authorizationUrl';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TopPage'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInWithGitHub,
          child: const Text('Sign in with GitHub'),
        ),
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
