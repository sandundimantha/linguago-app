import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/theme_preview_screen.dart';
import '../../features/lesson/lesson_screen.dart';
import '../../features/practice/practice_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // StatefulShellRoute keeps each tab's state alive when switching
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // 1. Home Tab Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // 2. Practice Tab Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/practice',
              builder: (context, state) => const PracticeScreen(),
            ),
          ],
        ),

        // 3. Progress Tab Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),

        // 4. Profile Tab Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Full-screen Lesson route (opens above shell, WITHOUT bottom navigation bar)
    GoRoute(
      path: '/lesson/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final lessonId = state.pathParameters['id'] ?? '1';
        return LessonScreen(lessonId: lessonId);
      },
    ),

    // Full-screen Design System Preview route
    GoRoute(
      path: '/preview',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ThemePreviewScreen(),
    ),
  ],
);
