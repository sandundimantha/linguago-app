import '../models/user_model.dart';

abstract class AuthRepository {
  /// Stream emitting user state changes (null when logged out)
  Stream<UserModel?> get authStateChanges;

  /// Current signed-in user snapshot
  UserModel? get currentUser;

  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword(String email, String password);

  /// Register a new account
  Future<UserModel> signUpWithEmailAndPassword(String name, String email, String password);

  /// Sign in with Google credential
  Future<UserModel> signInWithGoogle();

  /// Send password reset instructions
  Future<void> sendPasswordResetEmail(String email);

  /// Log out
  Future<void> signOut();
}

