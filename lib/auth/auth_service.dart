import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ? Mock User
  final String _mockUserKey = 'mock_user_email';
  final String _mockPasswordKeyPrefix = 'mock_user_password';

  bool get _isFirebaseAvailable => isFirebaseInitialized.value;

  Future<User?> getCurrentUser() async {
    if (_isFirebaseAvailable) {
      return _firebaseAuth.currentUser;
    } else {
      return await _getMockCurrentUser();
    }
  }

  // ? Email Sign In
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    if (_isFirebaseAvailable) {
      try {
        UserCredential userCredential = await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password);

        return userCredential;
      } on FirebaseException catch (e) {
        throw Exception(e);
      }
    } else {
      return _mockSignInWithEmailPassword(email, password);
    }
  }

  // ? Email Sign Up
  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    if (_isFirebaseAvailable) {
      try {
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        return userCredential;
      } on FirebaseException catch (e) {
        throw Exception(e);
      }
    } else {
      return _mockSignUpWithEmailPassword(email, password);
    }
  }

  // ? Sign Out
  Future<void> signOut() async {
    if (_isFirebaseAvailable) {
      final googleSignIn = GoogleSignIn();
      try {
        final isGoogleSignedIn = await googleSignIn.isSignedIn();
        if (isGoogleSignedIn) {
          await googleSignIn.signOut();
        }
      } catch (e) {
        debugPrint("GoogleSignOut error: $e");
      }
      await _firebaseAuth.signOut();
    } else {
      await _mockSignOut();
    }
  }

  // ? google sign in (hanya tersedia jika Firebase aktif)
  Future<UserCredential> signInWithGoogle() async {
    if (_isFirebaseAvailable) {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile', 'openid']);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'Login Canceled by user',
          message: 'Sign in aborted by user',
        );
      }
      final auth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } else {
      throw Exception(
        'Google Sign-In is only available with Firebase configured.',
      );
    }
  }

  // ? Error Message
  String getErrorMessage(String errorCode) {
    if (_isFirebaseAvailable) {
      if (errorCode.contains('wrong-password')) {
        return 'Password incorrect';
      } else if (errorCode.contains('user-not-found')) {
        return 'User not found';
      } else if (errorCode.contains('invalid-email')) {
        return 'Email does not exist';
      } else if (errorCode.contains('weak-password')) {
        return 'Password is too weak';
      } else if (errorCode.contains('email-already-in-use')) {
        return 'Email is already in use';
      } else {
        return 'An unexpected error occurred: $errorCode';
      }
    } else {
      // Custom error messages for mock login
      if (errorCode == 'mock_invalid_credentials') {
        return 'Mock: Invalid email or password.';
      } else if (errorCode == 'mock_email_exists') {
        return 'Mock: Email already registered.';
      } else {
        return 'Mock: firebase_options.dart is not set and still uses dummy';
      }
    }
  }

  // ! --- Mock Implementation ---

  Future<User?> _getMockCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_mockUserKey);
    if (email != null && email.isNotEmpty) {
      return _MockUser(email: email);
    }
    return null;
  }

  Future<UserCredential> _mockSignInWithEmailPassword(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString(_mockPasswordKeyPrefix + email);

    if (email == 'admin@gmail.com' && password == 'admin123' ||
        (storedPassword != null && storedPassword == password)) {
      await prefs.setString(_mockUserKey, email);
      return _MockUserCredential(_MockUser(email: email));
    } else {
      throw Exception('mock_invalid_credentials');
    }
  }

  Future<UserCredential> _mockSignUpWithEmailPassword(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_mockPasswordKeyPrefix + email)) {
      throw Exception('mock_email_exists');
    }

    await prefs.setString(_mockPasswordKeyPrefix + email, password);
    await prefs.setString(_mockUserKey, email);
    return _MockUserCredential(_MockUser(email: email));
  }

  Future<void> _mockSignOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mockUserKey);
  }
}

// --- Kelas Mock untuk meniru Firebase User dan UserCredential ---

class _MockUser implements User {
  @override
  final String email;

  _MockUser({required this.email});

  @override
  String? get displayName => email.split('@').first;

  @override
  // Implementasi dummy untuk properti User lainnya jika diperlukan
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockUserCredential implements UserCredential {
  @override
  final User user;

  _MockUserCredential(this.user);

  @override
  // Implementasi dummy untuk properti UserCredential lainnya
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
