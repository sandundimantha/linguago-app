import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';

class PreferencesRepository {
  static const String _keyUserPreferences = 'linguago_user_preferences';
  static const String _keyFirstLaunch = 'linguago_is_first_launch';

  final SharedPreferences _prefs;

  PreferencesRepository(this._prefs);

  static Future<PreferencesRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesRepository(prefs);
  }

  /// Load user preferences from local storage
  UserPreferences loadPreferences() {
    final raw = _prefs.getString(_keyUserPreferences);
    if (raw == null) {
      return const UserPreferences();
    }
    try {
      return UserPreferences.fromJson(raw);
    } catch (_) {
      return const UserPreferences();
    }
  }

  /// Save user preferences to local storage
  Future<void> savePreferences(UserPreferences preferences) async {
    await _prefs.setString(_keyUserPreferences, preferences.toJson());
  }

  /// Whether the user has launched the app for the first time
  bool isFirstLaunch() {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Marks first launch as completed
  Future<void> setFirstLaunchCompleted() async {
    await _prefs.setBool(_keyFirstLaunch, false);
  }

  /// Clear all saved preferences (e.g. on reset/testing)
  Future<void> clear() async {
    await _prefs.remove(_keyUserPreferences);
    await _prefs.remove(_keyFirstLaunch);
  }
}

