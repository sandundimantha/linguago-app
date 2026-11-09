import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/user_preferences.dart';
import 'lesson_repository.dart';

/// Firebase-backed Lesson and Progress repository that fully maintains
/// local caching and offline-first capabilities.
///
/// It uses Firestore with persistent offline caching (enabled by default)
/// and seamlessly mirrors all writes to local SharedPreferences and Firestore
/// whenever a user is signed in.
class FirebaseLessonRepository extends LessonRepository {
  final FirebaseFirestore _firestore;
  String? _userId;

  FirebaseLessonRepository(
    super.prefs, {
    FirebaseFirestore? firestore,
    this._userId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance {
    _initFirestoreSettings();
  }

  void _initFirestoreSettings() {
    try {
      // Configure Firestore offline persistence cache
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e) {
      // Settings might already be set or not supported on some platforms
      debugPrint('Firestore settings note: $e');
    }
  }

  /// Update the current active user ID (e.g., on auth state change)
  void setUserId(String? uid) {
    if (_userId != uid) {
      _userId = uid;
      if (uid != null) {
        // Trigger background sync from remote to local cache
        syncWithRemote(uid);
      }
    }
  }

  DocumentReference<Map<String, dynamic>>? get _userDocRef {
    if (_userId == null) return null;
    return _firestore.collection('users').doc(_userId);
  }

  // ── Overrides for LessonRepository operations ─────────────────────────────

  @override
  Future<void> markLessonCompleted(String lessonId) async {
    // 1. Instantly save locally (offline support guaranteed)
    await super.markLessonCompleted(lessonId);

    // 2. Sync to Firestore (queued offline if no internet)
    final ref = _userDocRef;
    if (ref != null) {
      try {
        await ref.set({
          'completedLessonIds': FieldValue.arrayUnion([lessonId]),
          'lastActiveAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore lesson completion sync deferred: $e');
      }
    }
  }

  @override
  Future<void> setHearts(int count) async {
    await super.setHearts(count);

    final ref = _userDocRef;
    if (ref != null) {
      try {
        await ref.set({
          'hearts': count.clamp(0, 5),
          'lastActiveAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore hearts sync deferred: $e');
      }
    }
  }

  @override
  Future<void> addXp(int xp) async {
    // Local write + daily history update
    await super.addXp(xp);

    final ref = _userDocRef;
    if (ref != null) {
      try {
        final today = LessonRepository.dateKey(DateTime.now());
        await ref.set({
          'totalXp': FieldValue.increment(xp),
          'dailyXpHistory.$today': FieldValue.increment(xp),
          'streakDates': FieldValue.arrayUnion([today]),
          'lastActiveAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore XP sync deferred: $e');
      }
    }
  }

  @override
  Future<void> setStreak(int streak) async {
    await super.setStreak(streak);

    final ref = _userDocRef;
    if (ref != null) {
      try {
        await ref.set({
          'streak': streak,
          'lastActiveAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore streak sync deferred: $e');
      }
    }
  }

  // ── Cloud Firestore Sync & Profile Management ──────────────────────────────

  /// Save or update user profile and preferences in Firestore
  Future<void> saveUserProfile({
    required UserModel user,
    UserPreferences? preferences,
  }) async {
    _userId = user.id;
    final ref = _firestore.collection('users').doc(user.id);

    final data = <String, dynamic>{
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (preferences != null) {
      data['preferences'] = {
        'nativeLanguage': preferences.nativeLanguage,
        'learningGoal': preferences.learningGoal,
        'englishLevel': preferences.englishLevel,
        'dailyGoalMinutes': preferences.dailyGoalMinutes,
        'assessedLevel': preferences.assessedLevel,
      };
    }

    try {
      await ref.set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Firestore profile save deferred: $e');
    }
  }

  /// Synchronize remote Firestore progress into local storage
  Future<void> syncWithRemote(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        // If doc does not exist yet on cloud, upload current local state
        await _uploadLocalProgressToRemote(uid);
        return;
      }

      final data = doc.data();
      if (data == null) return;

      // 1. Sync completed lessons (union)
      if (data['completedLessonIds'] is List) {
        final remoteLessons = List<String>.from(data['completedLessonIds']);
        final localSet = getCompletedLessonIds();
        localSet.addAll(remoteLessons);
        for (final id in localSet) {
          await super.markLessonCompleted(id);
        }
      }

      // 2. Sync Total XP (take max)
      if (data['totalXp'] is int) {
        final remoteXp = data['totalXp'] as int;
        final localXp = getTotalXp();
        if (remoteXp > localXp) {
          final diff = remoteXp - localXp;
          await super.addXp(diff);
        }
      }

      // 3. Sync Streak (take max)
      if (data['streak'] is int) {
        final remoteStreak = data['streak'] as int;
        if (remoteStreak > getStreak()) {
          await super.setStreak(remoteStreak);
        }
      }

      // 4. Sync streak dates
      if (data['streakDates'] is List) {
        final remoteDates = List<String>.from(data['streakDates']);
        final localDates = getStreakDates();
        final combined = {...localDates, ...remoteDates}.toList();
        for (final date in combined) {
          if (!localDates.contains(date)) {
            localDates.add(date);
          }
        }
      }
    } catch (e) {
      // Offline fallback: continue using local state without blocking
      debugPrint('Offline or remote sync error: $e');
    }
  }

  Future<void> _uploadLocalProgressToRemote(String uid) async {
    try {
      final ref = _firestore.collection('users').doc(uid);
      await ref.set({
        'completedLessonIds': getCompletedLessonIds().toList(),
        'totalXp': getTotalXp(),
        'streak': getStreak(),
        'hearts': getHearts(),
        'streakDates': getStreakDates(),
        'dailyXpHistory': getDailyXpHistory(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastActiveAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Could not upload initial local progress to remote: $e');
    }
  }
}

