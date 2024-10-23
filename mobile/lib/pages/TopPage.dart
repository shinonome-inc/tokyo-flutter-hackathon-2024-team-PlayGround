import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/SecureStorageRepository.dart';

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TopPage'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            await SecureStorageRepository().writeToken('test_token');
            context.go(RouterPaths.home);
          },
          child: const Text('GitHubでサインイン'),
        ),
      ),
    );
  }
}
