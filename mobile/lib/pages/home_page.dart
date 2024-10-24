import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ログアウト処理: セキュアストレージからアクセストークンを削除
  Future<void> _logout(BuildContext context) async {
    await SecureStorageRepository().deleteToken();
    print('アクセストークンを削除しました。');

    // ログイン画面に遷移
    context.go(RouterPaths.top); // ここでログインページに戻る
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () => _logout(context), icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('HomePage'),
            TextButton(
              onPressed: () {
                context.push(RouterPaths.ranking);
              },
              child: const Text('ランキング'),
            ),
            TextButton(
              onPressed: () {
                context.push(RouterPaths.dressUp);
              },
              child: const Text('着せ替え'),
            ),
            TextButton(
              onPressed: () {
                context.push(RouterPaths.makeover);
              },
              child: const Text('模様替え'),
            ),
            TextButton(
              onPressed: () {
                context.push(RouterPaths.setting);
              },
              child: const Text('設定'),
            ),
          ],
        ),
      ),
    );
  }
}
