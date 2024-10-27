import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/providers/launch_notifier.dart';

class LaunchPage extends ConsumerStatefulWidget {
  const LaunchPage({super.key});

  @override
  ConsumerState createState() => _LaunchPageState();
}

class _LaunchPageState extends ConsumerState<LaunchPage> {
  Future<void> _initialize() async {
    final notifier = ref.read(launchNotifierProvider.notifier);
    final isSignedIn = await notifier.isSignedIn();
    // NOTE: 一瞬の自動画面遷移でユーザーを混乱させないために意図的に1秒待機する。
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    if (isSignedIn) {
      context.go(RouterPaths.home);
      return;
    }
    context.go(RouterPaths.top);
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('LaunchPage'),
      ),
    );
  }
}
