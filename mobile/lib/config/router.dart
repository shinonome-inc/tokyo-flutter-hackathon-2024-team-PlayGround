import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/pages/DressUpPage.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/LaunchPage.dart';
import 'package:mobile/pages/MakeoverPage.dart';
import 'package:mobile/pages/RankingPage.dart';
import 'package:mobile/pages/SettingPage.dart';
import 'package:mobile/pages/TopPage.dart';

/// プロジェクトの画面遷移に関するルーティング設定です。
final router = GoRouter(
  initialLocation: '/launch',
  routes: [
    GoRoute(
      path: '/launch',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const LaunchPage(),
        );
      },
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        );
      },
    ),
    GoRoute(
      path: '/top',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TopPage(),
        );
      },
    ),
    GoRoute(
      path: '/dress-up',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const DressUpPage(),
        );
      },
    ),
    GoRoute(
      path: '/makeover',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const MakeoverPage(),
        );
      },
    ),
    GoRoute(
      path: '/ranking',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const RankingPage(),
        );
      },
    ),
    GoRoute(
      path: '/setting',
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
