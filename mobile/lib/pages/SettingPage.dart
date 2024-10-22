import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/repositories/SecureStorageRepository.dart';

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
                context.go('/top');
              },
              child: const Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}
