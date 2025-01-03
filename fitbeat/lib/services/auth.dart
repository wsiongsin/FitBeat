import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      if (name.isEmpty) {
        throw AuthException('Please enter your name.');
      }

      if (!_isValidEmail(email)) {
        throw AuthException('Please enter a valid email address.');
      }

      if (password.length < 6) {
        throw AuthException('Password must be at least 6 characters long.');
      }

      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with name
      await userCredential.user!.updateDisplayName(name);

      // Sign out the user immediately after creation
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException('This email is already registered.');
        case 'invalid-email':
          throw AuthException('Please enter a valid email address.');
        case 'operation-not-allowed':
          throw AuthException('Email/password accounts are not enabled.');
        case 'weak-password':
          throw AuthException('Please enter a stronger password.');
        default:
          throw AuthException('An error occurred. Please try again.');
      }
    } catch (e) {
      throw AuthException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      if (!_isValidEmail(email)) {
        throw AuthException('Please enter a valid email address.');
      }

      if (password.isEmpty) {
        throw AuthException('Please enter your password.');
      }

      // Sign in user
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw AuthException('User not found.');
      }

      // Save session locally
      await _saveUserSession(user.uid, email, user.displayName ?? '');

      return {
        'id': user.uid,
        'name': user.displayName ?? '',
        'email': email,
      };
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw AuthException('No user found with this email.');
        case 'wrong-password':
          throw AuthException('Invalid password.');
        case 'invalid-email':
          throw AuthException('Please enter a valid email address.');
        case 'user-disabled':
          throw AuthException('This account has been disabled.');
        default:
          throw AuthException('An error occurred. Please try again.');
      }
    } catch (e) {
      throw AuthException('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> _saveUserSession(
      String userId, String email, String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', name);
    } catch (e) {
      throw AuthException('Failed to save session');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<bool> isSignedIn() async {
    try {
      final currentUser = _auth.currentUser;
      return currentUser != null;
    } catch (e) {
      return false;
    }
  }
}
