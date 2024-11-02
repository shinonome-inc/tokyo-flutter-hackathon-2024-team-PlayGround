import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/providers/top_notifier.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TopPage extends ConsumerStatefulWidget {
  const TopPage({super.key});

  @override
  ConsumerState createState() => _TopPageState();
}

class _TopPageState extends ConsumerState<TopPage> {
  final clientId = dotenv.env['GITHUB_CLIENT_ID']!;
  final String redirectUri = 'https://shinonome.com';
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
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
              if (code == null) return;

              handleAuthCallback(code); // 認証コードを処理
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
    final notifier = ref.read(topNotifierProvider.notifier);
    notifier.setShowWebView(true);
    final authorizationUrl =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=repo,read:org,read:user,user:email';
    _controller.loadRequest(Uri.parse(authorizationUrl));
  }

  Future<void> handleAuthCallback(String code) async {
    final state = ref.read(topNotifierProvider);
    final notifier = ref.read(topNotifierProvider.notifier);

    if (!state.isLoading) return;
    notifier.setLoading(true);
    String token = '';
    try {
      token = await RepositoriClient.instance.fetchAccessToken(code);
    } catch (e) {
      // TODO: エラー処理を追加する。
      throw Exception('Failed to fetch access token: $e');
    } finally {
      notifier.setShowWebView(false);
      notifier.setLoading(false);
    }
    await SecureStorageRepository().writeToken(token);
    if (!mounted) return;
    context.go(RouterPaths.home);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(topNotifierProvider);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            ImagePaths.launchCover,
            fit: BoxFit.cover,
          ),
          Container(
            color: AppColors.black.withOpacity(0.6),
          ),
          ElevatedButton(
            onPressed: _launchGitHubAuth,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 28.w,
                  child: Image.asset(ImagePaths.githubMark),
                ),
                SizedBox(width: 12.w),
                Text(
                  'GitHubでログイン',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: AppColors.githubSignInButtonBackground,
                  ),
                ),
              ],
            ),
          ),
          if (state.showWebView)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.white,
              child: WebViewWidget(controller: _controller),
            ),
        ],
      ),
    );
  }
}
