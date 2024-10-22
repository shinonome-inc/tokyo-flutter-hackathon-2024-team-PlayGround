import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('HomePage'),
            TextButton(
              onPressed: () {
                context.go('/ranking');
              },
              child: const Text('ランキング'),
            ),
            TextButton(
              onPressed: () {
                context.go('/dress-up');
              },
              child: const Text('着せ替え'),
            ),
            TextButton(
              onPressed: () {
                context.go('/makeover');
              },
              child: const Text('模様替え'),
            ),
            TextButton(
              onPressed: () {
                context.go('/setting');
              },
              child: const Text('設定'),
            ),
          ],
        ),
      ),
    );
  }
}
