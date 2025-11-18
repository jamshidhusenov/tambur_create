import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tambur_create/core/services/version_checker/version_update_screen.dart';
import 'package:tambur_create/features/login/presentation/pages/login_page.dart';
import 'package:tambur_create/features/otk/presentation/pages/otk_form_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'initial',
      builder: (context, state) {
        final loginBox = Hive.box('login');

        if (loginBox.isEmpty) {
          return const LoginPage();
        } else {
          return const OtkFormPage();
        }
      },
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const OtkFormPage(),
    ),

    GoRoute(
      path: '/version_update',
      name: 'version_update',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>?;
        return VersionUpdateScreen(
          currentVersion: extra?['currentVersion'] ?? 'Unknown',
          serverVersion: extra?['serverVersion'] ?? 'Unknown',
          message: extra?['message'] ?? '',
        );
      },
    ),
  ],
  errorBuilder: (context, state) =>
      const Scaffold(body: Center(child: Text("Error page not found"))),
);
