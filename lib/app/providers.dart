import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/models/user_preferences.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/fake_auth_repository.dart';
import '../data/repositories/preferences_repository.dart';

// ── Repositories ─────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

final preferencesRepositoryProvider =
    FutureProvider<PreferencesRepository>((ref) async {
  return PreferencesRepository.create();
});

// ── Auth State ────────────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

// ── User Preferences ──────────────────────────────────────────────────────────

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

// ── First-launch Flag ─────────────────────────────────────────────────────────

final isFirstLaunchProvider = FutureProvider<bool>((ref) async {
  final repoAsync = ref.watch(preferencesRepositoryProvider);
  final repo = await repoAsync.future;
  return repo.isFirstLaunch();
});

// ── Auth Actions ──────────────────────────────────────────────────────────────

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

