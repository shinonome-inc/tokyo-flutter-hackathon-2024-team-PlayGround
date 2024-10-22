import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/pages/DressUpPage.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/LaunchPage.dart';
import 'package:mobile/pages/TopPage.dart';

/// プロジェクトの画面遷移に関するルーティング設定です。
final router = GoRouter(
  initialLocation: '/launch',
  routes: [
    GoRoute(
      path: '/launch',
      name: 'launch',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const LaunchPage(),
        );
      },
    ),
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        );
      },
    ),
    GoRoute(
      path: '/top',
      name: 'top',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const TopPage(),
        );
      },
    ),
    GoRoute(
      path: '/dress-up',
      name: 'dress-up',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const DressUpPage(),
        );
      },
    ),
    GoRoute(
      path: '/makeover',
      name: 'makeover',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const DressUpPage(),
        );
      },
    ),
    GoRoute(
      path: '/ranking',
      name: 'ranking',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const DressUpPage(),
        );
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const DressUpPage(),
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
