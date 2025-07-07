import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // ? Email Sign In
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // ? Email Sign Up
  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // ? Sign Out
  Future<void> signOut() async {
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

    selectedPageNotifier.value = 0;
  }

  // ? google sign in
  Future<UserCredential> signInWithGoogle() async {
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
  }

  // ? Error Message
  String getErrorMessage(String errorCode) {
    if (errorCode.contains('wrong-password')) {
      return 'Password incorrect';
    } else if (errorCode.contains('user-not-found')) {
      return 'User not found';
    } else if (errorCode.contains('invalid-email')) {
      return 'Email does not exist';
    } else {
      return 'An unexpected error occurred';
    }
  }
}
