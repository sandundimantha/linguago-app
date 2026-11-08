import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final fb_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository({
    fb_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUser);
  }

  @override
  UserModel? get currentUser {
    return _mapFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = _mapFirebaseUser(credential.user);
      if (user == null) {
        throw Exception('User authentication failed');
      }
      return user;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final fbUser = credential.user;
      if (fbUser != null && name.trim().isNotEmpty) {
        await fbUser.updateDisplayName(name.trim());
      }
      final user = _mapFirebaseUser(fbUser);
      if (user == null) {
        throw Exception('User registration failed');
      }
      return user;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final fb_auth.AuthCredential credential =
          fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = _mapFirebaseUser(userCredential.user);
      if (user == null) {
        throw Exception('Google Sign-In failed');
      }
      return user;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on fb_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  UserModel? _mapFirebaseUser(fb_auth.User? user) {
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName?.isNotEmpty == true
          ? user.displayName!
          : (user.email?.split('@').first ?? 'Learner'),
      email: user.email ?? '',
      avatarUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  Exception _handleFirebaseAuthException(fb_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No account found with this email.');
      case 'wrong-password':
      case 'invalid-credential':
        return Exception('Incorrect email or password. Please try again.');
      case 'email-already-in-use':
        return Exception('An account with this email already exists.');
      case 'invalid-email':
        return Exception('The email address is badly formatted.');
      case 'weak-password':
        return Exception('The password provided is too weak.');
      case 'user-disabled':
        return Exception('This account has been disabled.');
      default:
        return Exception(e.message ?? 'An authentication error occurred.');
    }
  }
}
