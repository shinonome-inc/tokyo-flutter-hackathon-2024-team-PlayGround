import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.backgroundSummer),
            fit: BoxFit.cover,
          ),
        ),
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
