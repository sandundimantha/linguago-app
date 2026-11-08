import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/log_in_screen.dart';
import '../../features/auth/sign_up_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/theme_preview_screen.dart';
import '../../features/lesson/learning_path_screen.dart';
import '../../features/lesson/lesson_screen.dart';
import '../../features/onboarding/daily_goal_screen.dart';
import '../../features/onboarding/learning_goal_screen.dart';
import '../../features/onboarding/level_screen.dart';
import '../../features/onboarding/native_language_screen.dart';
import '../../features/onboarding/placement_result_screen.dart';
import '../../features/onboarding/placement_test_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/welcome_slides_screen.dart';
import '../../features/practice/practice_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../providers.dart';
import '../scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter buildAppRouter(WidgetRef ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final prefsAsync = ref.read(preferencesRepositoryProvider);
      // While the repo is still loading, don't redirect anywhere.
      final repo = prefsAsync.valueOrNull;
      if (repo == null) return null;

      final isFirst = repo.isFirstLaunch();
      final onOnboardingOrAuth =
          state.matchedLocation.startsWith('/onboarding') ||
              state.matchedLocation.startsWith('/auth');

      // First launch → force onboarding
      if (isFirst && !onOnboardingOrAuth) {
        return '/onboarding/splash';
      }

      return null; // no redirect needed
    },
    routes: [
      // ── Onboarding routes (full-screen, no bottom bar) ──────────────
      GoRoute(
        path: '/onboarding/splash',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding/welcome',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const WelcomeSlidesScreen(),
      ),
      GoRoute(
        path: '/onboarding/language',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NativeLanguageScreen(),
      ),
      GoRoute(
        path: '/onboarding/goal',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LearningGoalScreen(),
      ),
      GoRoute(
        path: '/onboarding/level',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LevelScreen(),
      ),
      GoRoute(
        path: '/onboarding/placement',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PlacementTestScreen(),
      ),
      GoRoute(
        path: '/onboarding/placement-result',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final score = state.extra as int? ?? 0;
          return PlacementResultScreen(score: score);
        },
      ),
      GoRoute(
        path: '/onboarding/daily-goal',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const DailyGoalScreen(),
      ),
      GoRoute(
        path: '/onboarding/sign-up',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SignUpScreen(),
      ),

      // ── Auth routes (full-screen, no bottom bar) ────────────────────
      GoRoute(
        path: '/auth/sign-up',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LogInScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ── Learning Path route (full-screen, above shell) ──────────────
      GoRoute(
        path: '/learning-path',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LearningPathScreen(),
      ),

      // ── Main shell (4-tab bottom nav) ───────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/practice',
                builder: (context, state) => const PracticeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
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

      // ── Full-screen lesson (above shell, no bottom bar) ─────────────
      GoRoute(
        path: '/lesson/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final lessonId = state.pathParameters['id'] ?? '1';
          return LessonScreen(lessonId: lessonId);
        },
      ),

      // ── Design System preview ────────────────────────────────────────
      GoRoute(
        path: '/preview',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ThemePreviewScreen(),
      ),
    ],
  );
}
