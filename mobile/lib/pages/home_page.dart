import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/constants/router_paths.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            ImagePaths.backgroundSummer,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Image.asset(
            ImagePaths.dash,
            width: 200,
          ),
          Row(
            children: [
              Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        context.go(RouterPaths.ranking);
                      },
                      child: const Text('ランキング'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go(RouterPaths.makeover);
                      },
                      child: const Text('メイクオーバー'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go(RouterPaths.dressUp);
                      },
                      child: const Text('ドレスアップ'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go(RouterPaths.setting);
                      },
                      child: const Text('設定'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
