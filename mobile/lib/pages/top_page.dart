import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/providers/top_notifier.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TopPage extends ConsumerStatefulWidget {
  const TopPage({super.key});

  @override
  ConsumerState createState() => _TopPageState();
}

class _TopPageState extends ConsumerState<TopPage> {
  late WebViewController _controller;
  late String authorizationUrl;

  Future<void> _onUrlChange(UrlChange urlChange) async {
    if (!mounted) return;

    final redirectUri = dotenv.env['GITHUB_REDIRECT_URL'];
    if (urlChange.url == null || redirectUri == null) return;

    final isNotRedirectUri = !urlChange.url!.startsWith(redirectUri);
    if (isNotRedirectUri) return;

    final notifier = ref.read(topNotifierProvider.notifier);
    try {
      await notifier.signInByRedirectUrl(urlChange.url!);
    } catch (e) {
      return;
    }
    if (!mounted) return;
    context.go(RouterPaths.home);
  }

  Future<void> _onPressedSignInWithGitHubButton() async {
    if (!mounted) return;
    _controller.loadRequest(Uri.parse(authorizationUrl));
  }

  @override
  void initState() {
    super.initState();
    final clientId = dotenv.env['GITHUB_CLIENT_ID'];
    final redirectUri = dotenv.env['GITHUB_REDIRECT_URL'];
    authorizationUrl =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=repo';
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(onUrlChange: _onUrlChange),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TopPage'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: WebViewWidget(controller: _controller)),
          ElevatedButton(
            onPressed: _onPressedSignInWithGitHubButton,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign in with GitHub'),
          ),
        ],
      ),
    );
  }
}
