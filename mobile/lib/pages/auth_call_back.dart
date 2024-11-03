import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/components/top_cover_view.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/services/repositori_client.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  @override
  void initState() {
    super.initState();
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
      final token = await RepositoriClient.instance.fetchAccessToken(code);
      // アクセストークンをセキュアストレージに保存
      await SecureStorageRepository().writeToken(token);
      if (mounted) {
        context.go(RouterPaths.home); // 認証成功時にホーム画面に遷移
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      // 必要に応じてエラーハンドリングを行います。
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const TopCoverView(),
          Container(
            color: AppColors.black.withOpacity(0.6),
          ),
          Image.asset(ImagePaths.authLoading),
        ],
      ),
    );
  }
}
