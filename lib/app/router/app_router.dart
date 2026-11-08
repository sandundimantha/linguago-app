import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/log_in_screen.dart';
import '../../features/auth/sign_up_screen.dart';
import '../../features/dictionary/dictionary_result_screen.dart';
import '../../features/dictionary/dictionary_search_screen.dart';
import '../../features/grammar/grammar_exercise_screen.dart';
import '../../features/grammar/grammar_hub_screen.dart';
import '../../features/grammar/rule_card_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/theme_preview_screen.dart';
import '../../features/lesson/learning_path_screen.dart';
import '../../features/lesson/lesson_screen.dart';
import '../../features/listening/audio_player_screen.dart';
import '../../features/listening/listening_hub_screen.dart';
import '../../features/onboarding/daily_goal_screen.dart';
import '../../features/onboarding/learning_goal_screen.dart';
import '../../features/onboarding/level_screen.dart';
import '../../features/onboarding/native_language_screen.dart';
import '../../features/onboarding/placement_result_screen.dart';
import '../../features/onboarding/placement_test_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/welcome_slides_screen.dart';
import '../../features/practice/practice_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/progress/badges_screen.dart';
import '../../features/progress/friends_screen.dart';
import '../../features/progress/leaderboard_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/progress/streak_calendar_screen.dart';
import '../../features/settings/about_screen.dart';
import '../../features/settings/help_faq_screen.dart';
import '../../features/settings/notification_settings_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/speaking/pronunciation_practice_screen.dart';
import '../../features/ai_chat/scenario_picker_screen.dart';
import '../../features/ai_chat/ai_chat_screen.dart';
import '../../features/premium/paywall_screen.dart';
import '../../features/premium/checkout_screen.dart';
import '../../data/models/ai_chat_models.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../features/vocabulary/flashcards_screen.dart';
import '../../features/vocabulary/review_session_screen.dart';
import '../../features/vocabulary/vocab_hub_screen.dart';
import '../../features/vocabulary/word_detail_screen.dart';
import '../../features/vocabulary/word_list_screen.dart';
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

      // ── Vocabulary Subsystem Routes ─────────────────────────────────
      GoRoute(
        path: '/vocab',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const VocabHubScreen(),
      ),
      GoRoute(
        path: '/vocab/list',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const WordListScreen(),
      ),
      GoRoute(
        path: '/vocab/word/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final wordId = state.pathParameters['id'] ?? 'v1';
          return WordDetailScreen(wordId: wordId);
        },
      ),
      GoRoute(
        path: '/vocab/flashcards',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const FlashcardsScreen(),
      ),
      GoRoute(
        path: '/vocab/review',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ReviewSessionScreen(),
      ),

      // ── Grammar Subsystem Routes ────────────────────────────────────
      GoRoute(
        path: '/grammar',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const GrammarHubScreen(),
      ),
      GoRoute(
        path: '/grammar/topic/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final topicId = state.pathParameters['id'] ?? 'g1';
          return RuleCardScreen(topicId: topicId);
        },
      ),
      GoRoute(
        path: '/grammar/exercise/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final topicId = state.pathParameters['id'] ?? 'g1';
          return GrammarExerciseScreen(topicId: topicId);
        },
      ),

      // ── Listening Subsystem Routes ──────────────────────────────────
      GoRoute(
        path: '/listening',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ListeningHubScreen(),
      ),
      GoRoute(
        path: '/listening/player/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final trackId = state.pathParameters['id'] ?? 'track_1';
          return AudioPlayerScreen(trackId: trackId);
        },
      ),

      // ── Speaking Subsystem Routes ───────────────────────────────────
      GoRoute(
        path: '/speaking',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PronunciationPracticeScreen(),
      ),

      // ── Dictionary Routes ───────────────────────────────────────────
      GoRoute(
        path: '/dictionary',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const DictionarySearchScreen(),
      ),
      GoRoute(
        path: '/dictionary/result/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final wordId = state.pathParameters['id'] ?? 'v1';
          return DictionaryResultScreen(wordId: wordId);
        },
      ),

      // ── Progress Subsystem Detail Routes ────────────────────────────
      GoRoute(
        path: '/progress/streak',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const StreakCalendarScreen(),
      ),
      GoRoute(
        path: '/progress/badges',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BadgesScreen(),
      ),
      GoRoute(
        path: '/progress/leaderboard',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/progress/friends',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const FriendsScreen(),
      ),

      // ── Profile & Settings Routes ───────────────────────────────────
      GoRoute(
        path: '/profile/edit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/help-faq',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const HelpFaqScreen(),
      ),
      GoRoute(
        path: '/about',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
      ),

      // ── AI Conversation & Premium Routes ────────────────────────────
      GoRoute(
        path: '/ai-scenarios',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ScenarioPickerScreen(),
      ),
      GoRoute(
        path: '/ai-chat',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final scenario = state.extra as ScenarioModel? ??
              const ScenarioModel(
                id: 'cafe_order',
                title: 'Ordering at a Café',
                subtitle: 'Order coffee and food',
                category: 'Daily Life',
                aiRole: 'Barista',
                userRole: 'Customer',
                initialAiMessage: 'Hi! What can I get for you today?',
                level: 'Beginner',
                iconName: 'local_cafe_rounded',
                emoji: '☕',
                backgroundHint: 'Practice ordering politely.',
              );
          return AiChatScreen(scenario: scenario);
        },
      ),
      GoRoute(
        path: '/premium/paywall',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/premium/checkout',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final product = extra['product'] as ProductDetails?;
          final planIndex = extra['planIndex'] as int? ?? 1;
          return CheckoutScreen(
            product: product,
            planIndex: planIndex,
          );
        },
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
