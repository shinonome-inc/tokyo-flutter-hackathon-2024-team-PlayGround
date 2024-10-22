import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/repositories/SecureStorageRepository.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      final token = await SecureStorageRepository().readToken();
      if (!mounted) return;
      if (token == null) {
        context.go('/top');
        return;
      }
      context.go('/');
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
