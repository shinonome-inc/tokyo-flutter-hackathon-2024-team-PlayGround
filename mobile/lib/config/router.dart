import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/pages/DressUpPage.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/LaunchPage.dart';
import 'package:mobile/pages/MakeoverPage.dart';
import 'package:mobile/pages/RankingPage.dart';
import 'package:mobile/pages/SettingPage.dart';
import 'package:mobile/pages/TopPage.dart';

/// プロジェクトの画面遷移に関するルーティング設定です。
final router = GoRouter(
  initialLocation: RouterPaths.launch,
  routes: [
    GoRoute(
      path: RouterPaths.launch,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const LaunchPage(),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.home,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.top,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TopPage(),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.dressUp,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const DressUpPage(),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.makeover,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const MakeoverPage(),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.ranking,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const RankingPage(),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.setting,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SettingPage(),
        );
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  ),
);
