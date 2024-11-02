import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/providers/launch_notifier.dart';

class LaunchPage extends ConsumerStatefulWidget {
  const LaunchPage({super.key});

  @override
  ConsumerState createState() => _LaunchPageState();
}

class _LaunchPageState extends ConsumerState<LaunchPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      final notifier = ref.read(launchNotifierProvider.notifier);
      final isSignedIn = await notifier.isSignedIn();
      if (!mounted) return;
      if (isSignedIn) {
        context.go(RouterPaths.top);
        return;
      }
      context.go(RouterPaths.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(launchNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: AnimatedOpacity(
        opacity: state.opacity,
        duration: const Duration(seconds: 1),
        child: Image.asset(
          ImagePaths.launchCover,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
