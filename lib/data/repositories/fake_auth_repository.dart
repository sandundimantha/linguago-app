import 'dart:async';
import '../models/user_model.dart';
import 'auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  UserModel? _currentUser;
  final _controller = StreamController<UserModel?>.broadcast();

  // In-memory fake user database
  final Map<String, String> _userPasswords = {
    'alex@linguago.com': 'password123',
    'student@test.com': 'password123',
  };

  final Map<String, UserModel> _users = {
    'alex@linguago.com': UserModel(
      id: 'user_1',
      name: 'Alex',
      email: 'alex@linguago.com',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB1raLnqEpiWWLClcQ-TJp1sN7vxaXSRlLPfLdQY3zQHGPDPML4Xb4ixiobcV80PQIecFjtVnAtjy8qWlwSUvxNXrbteETamMEirqosK5BCCAgJoGFuB61OSPO9R09OkxVNpOkj_usCCzLd5wj0bkaUJCOMCL6_cs9F4KmlYXNmfPH2SLsh2zyj9t3Xm4XUn3uvL0iZkc4yfhzBd8ZltpAwpTqeaWAtsv-HqEhhsYQG',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  };

  FakeAuthRepository({UserModel? initialUser}) {
    if (initialUser != null) {
      _currentUser = initialUser;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    // Simulate real network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();

    if (_userPasswords.containsKey(normalizedEmail)) {
      if (_userPasswords[normalizedEmail] != password) {
        throw Exception('Incorrect password. Please try again.');
      }
      _currentUser = _users[normalizedEmail];
    } else {
      // Allow seamless mock sign-in for new test accounts
      final newUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: normalizedEmail.split('@').first,
        email: normalizedEmail,
        createdAt: DateTime.now(),
      );
      _users[normalizedEmail] = newUser;
      _userPasswords[normalizedEmail] = password;
      _currentUser = newUser;
    }

    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();

    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: normalizedEmail,
      createdAt: DateTime.now(),
    );

    _users[normalizedEmail] = newUser;
    _userPasswords[normalizedEmail] = password;
    _currentUser = newUser;
    _controller.add(_currentUser);

    return newUser;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final googleUser = UserModel(
      id: 'google_user_demo',
      name: 'Alex Google',
      email: 'alex.google@example.com',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB1raLnqEpiWWLClcQ-TJp1sN7vxaXSRlLPfLdQY3zQHGPDPML4Xb4ixiobcV80PQIecFjtVnAtjy8qWlwSUvxNXrbteETamMEirqosK5BCCAgJoGFuB61OSPO9R09OkxVNpOkj_usCCzLd5wj0bkaUJCOMCL6_cs9F4KmlYXNmfPH2SLsh2zyj9t3Xm4XUn3uvL0iZkc4yfhzBd8ZltpAwpTqeaWAtsv-HqEhhsYQG',
      createdAt: DateTime.now(),
    );
    _currentUser = googleUser;
    _controller.add(_currentUser);
    return googleUser;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulated success
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}

