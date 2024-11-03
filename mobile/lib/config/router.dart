import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/router_paths.dart';
import 'package:mobile/pages/dress_up_page.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/launch_page.dart';
import 'package:mobile/pages/makeover_page.dart';
import 'package:mobile/pages/ranking_page.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mobile/pages/top_page.dart';
import 'package:mobile/pages/food_page.dart';
import 'package:mobile/pages/auth_call_back.dart';

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
      path: RouterPaths.authCallback,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const AuthCallbackPage(),
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
      path: RouterPaths.settings,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SettingsPage(),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.food,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const FoodPage(),
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
