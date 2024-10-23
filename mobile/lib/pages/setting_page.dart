import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SettingPage'),
            TextButton(
              onPressed: () async {
                await SecureStorageRepository().deleteToken();
                context.go(RouterPaths.top);
              },
              child: const Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}
