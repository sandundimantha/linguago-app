import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/models/user_preferences.dart';
import '../data/models/lesson_models.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/fake_auth_repository.dart';
import '../data/repositories/firebase_auth_repository.dart';
import '../data/repositories/preferences_repository.dart';
import '../data/repositories/lesson_repository.dart';
import '../data/repositories/firebase_lesson_repository.dart';
import '../data/repositories/spaced_repetition_scheduler.dart';
import '../data/repositories/vocab_grammar_repository.dart';
import '../data/models/vocab_grammar_models.dart';
import '../data/models/audio_track.dart';
import '../core/services/speech_service.dart';
import '../core/services/speech_service_impl.dart';
import '../core/services/ai_tutor_service.dart';
import '../core/services/ai_tutor_service_impl.dart';
import '../core/services/in_app_purchase_service.dart';
import '../features/lesson/controllers/lesson_controller.dart';

// ── Repositories ─────────────────────────────────────────────────────────────

/// Global flag to switch between Firebase and Fake/Local repositories if needed.
/// Defaults to true so Firebase is active.
final useFirebaseProvider = StateProvider<bool>((ref) => true);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final useFirebase = ref.watch(useFirebaseProvider);
  if (useFirebase) {
    try {
      return FirebaseAuthRepository();
    } catch (_) {
      // Graceful fallback to FakeAuthRepository if Firebase is uninitialized
      return FakeAuthRepository();
    }
  }
  return FakeAuthRepository();
});

final preferencesRepositoryProvider =
    FutureProvider<PreferencesRepository>((ref) async {
  return PreferencesRepository.create();
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  final prefsAsync = ref.watch(preferencesRepositoryProvider);
  final repo = prefsAsync.valueOrNull;
  if (repo == null) {
    throw Exception('PreferencesRepository not ready yet');
  }

  final useFirebase = ref.watch(useFirebaseProvider);
  if (useFirebase) {
    try {
      final user = ref.watch(authStateProvider).valueOrNull;
      final fbRepo = FirebaseLessonRepository(
        repo.prefs,
        userId: user?.id,
      );
      return fbRepo;
    } catch (_) {
      return LessonRepository(repo.prefs);
    }
  }

  return LessonRepository(repo.prefs);
});

final srsSchedulerProvider = Provider<SpacedRepetitionScheduler>((ref) {
  final prefsAsync = ref.watch(preferencesRepositoryProvider);
  final repo = prefsAsync.valueOrNull;
  if (repo == null) {
    throw Exception('PreferencesRepository not ready yet');
  }
  return SpacedRepetitionScheduler(repo.prefs);
});

final vocabGrammarRepoProvider = Provider<VocabGrammarRepository>((ref) {
  final srs = ref.watch(srsSchedulerProvider);
  return VocabGrammarRepository(srs);
});

final vocabListProvider = FutureProvider<List<VocabWord>>((ref) async {
  final repo = ref.watch(vocabGrammarRepoProvider);
  return repo.loadVocab();
});

final grammarTopicsProvider = FutureProvider<List<GrammarTopic>>((ref) async {
  final repo = ref.watch(vocabGrammarRepoProvider);
  return repo.loadGrammar();
});

final dueWordsProvider = FutureProvider<List<VocabWord>>((ref) async {
  final repo = ref.watch(vocabGrammarRepoProvider);
  return repo.getDueWords();
});

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SpeechServiceImpl();
});

final aiTutorServiceImplementationProvider =
    Provider<AiTutorService>((ref) {
  return AiTutorServiceImpl();
});

final inAppPurchaseServiceProvider = Provider<InAppPurchaseService>((ref) {
  final prefsAsync = ref.watch(preferencesRepositoryProvider);
  final repo = prefsAsync.valueOrNull;
  if (repo == null) {
    throw Exception('PreferencesRepository not ready yet');
  }
  final service = InAppPurchaseService(repo.prefs);
  service.init();
  ref.onDispose(() => service.dispose());
  return service;
});

final isPremiumUserProvider = StateProvider<bool>((ref) {
  try {
    final iap = ref.watch(inAppPurchaseServiceProvider);
    return iap.isPremium();
  } catch (_) {
    return false;
  }
});

final audioTracksProvider = FutureProvider<List<AudioTrack>>((ref) async {
  final raw = await rootBundle.loadString('assets/audio_samples.json');
  final list = (json.decode(raw) as List)
      .map((e) => AudioTrack.fromJson(e as Map<String, dynamic>))
      .toList();
  return list;
});

final unitsProvider = FutureProvider<List<UnitModel>>((ref) async {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.loadUnits();
});

final completedLessonIdsProvider = Provider<Set<String>>((ref) {
  final repo = ref.watch(lessonRepositoryProvider);
  return repo.getCompletedLessonIds();
});

final lessonControllerProvider = StateNotifierProvider.autoDispose
    .family<LessonController, LessonState, LessonModel>((ref, lesson) {
  final repo = ref.watch(lessonRepositoryProvider);
  return LessonController(repo, lesson);
});

// ── Auth State ───────────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

// ── User Preferences ─────────────────────────────────────────────────────────

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  final PreferencesRepository _repo;

  UserPreferencesNotifier(this._repo) : super(_repo.loadPreferences());

  Future<void> setNativeLanguage(String lang) async {
    state = state.copyWith(nativeLanguage: lang);
    await _repo.savePreferences(state);
  }

  Future<void> setLearningGoal(String goal) async {
    state = state.copyWith(learningGoal: goal);
    await _repo.savePreferences(state);
  }

  Future<void> setEnglishLevel(String level) async {
    state = state.copyWith(englishLevel: level);
    await _repo.savePreferences(state);
  }

  Future<void> setPlacementResult(int score, String assessedLevel) async {
    state = state.copyWith(placementScore: score, assessedLevel: assessedLevel);
    await _repo.savePreferences(state);
  }

  Future<void> setDailyGoal(int minutes) async {
    state = state.copyWith(dailyGoalMinutes: minutes);
    await _repo.savePreferences(state);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isOnboardingCompleted: true);
    await _repo.savePreferences(state);
    await _repo.setFirstLaunchCompleted();
  }

  Future<void> reset() async {
    await _repo.clear();
    state = const UserPreferences();
  }
}

final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  final repoAsync = ref.watch(preferencesRepositoryProvider);
  final repo = repoAsync.valueOrNull;
  if (repo == null) {
    throw Exception('PreferencesRepository not ready yet');
  }
  return UserPreferencesNotifier(repo);
});

// ── First-launch Flag ────────────────────────────────────────────────────────

final isFirstLaunchProvider = FutureProvider<bool>((ref) async {
  final repo = await ref.watch(preferencesRepositoryProvider.future);
  return repo.isFirstLaunch();
});

// ── Auth Actions ─────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _auth;

  AuthNotifier(this._auth) : super(const AsyncValue.data(null));

  Future<UserModel?> signUp(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _auth.signUpWithEmailAndPassword(name, email, password);
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<UserModel?> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _auth.signInWithEmailAndPassword(email, password);
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _auth.signInWithGoogle();
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _auth.sendPasswordResetEmail(email);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void clearError() {
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
