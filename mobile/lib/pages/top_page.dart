import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/components/top_cover_view.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/providers/top_notifier.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
import 'package:mobile/services/repositori_client.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TopPage extends ConsumerStatefulWidget {
  const TopPage({super.key});

  @override
  ConsumerState createState() => _TopPageState();
}

class _TopPageState extends ConsumerState<TopPage> {
  final clientId = dotenv.env['GITHUB_CLIENT_ID']!;
  final baseUrl = dotenv.env['ENDPOINT']!;
  final String redirectUri =
      'https://d35ev4qyh6i48b.cloudfront.net/auth-callback';

  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  // GitHubの認証ページをブラウザで開く
  void _launchGitHubAuth() async {
    final notifier = ref.read(topNotifierProvider.notifier);
    notifier.setShowWebView(true);
    final authorizationUrl =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=repo,read:org,read:user,user:email';
    if (await canLaunchUrl(Uri.parse(authorizationUrl))) {
      await launchUrl(Uri.parse(authorizationUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $authorizationUrl';
    }
  }

  Future<void> handleAuthCallback(String code) async {
    final state = ref.read(topNotifierProvider);
    final notifier = ref.read(topNotifierProvider.notifier);

    if (state.isLoading) return;
    notifier.setLoading(true);
    String token = '';
    try {
      token = await RepositoriClient.instance.fetchAccessToken(code);
      print('token: $token');
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
          const TopCoverView(),
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
