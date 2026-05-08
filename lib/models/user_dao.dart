import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDao extends ChangeNotifier {
  final auth = FirebaseAuth.instance;

  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String? userId() {
    return auth.currentUser?.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }

  Future<String?> signup(String email, String password) async {
    try {
      if (email.isEmpty) return 'Please enter an email.';
      if (password.isEmpty) return 'Please enter a password.';

      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      log('Signup Error Code: ${e.code}');
      switch (e.code) {
        case 'email-already-in-use':
          return 'This account already exists. Try logging in.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'weak-password':
          return 'The password is too weak.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        default:
          return 'Registration failed: ${e.message ?? 'Unknown error'}';
      }
    } catch (e) {
      log('Signup Exception: $e');
      return 'An unexpected error occurred.';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      if (email.isEmpty) return 'Please enter your email.';
      if (password.isEmpty) return 'Please enter your password.';

      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      log('Login Error Code: ${e.code}');
      
      // Map security codes to user-friendly messages
      if (e.code == 'invalid-credential' || e.code == 'wrong-password'
          || e.code == 'user-not-found') {
        return 'Incorrect email or password.';
      }
      
      switch (e.code) {
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        case 'internal-error':
        case 'channel-error':
          return 'Connection error. Please try again.';
        default:
          return 'Login failed. Please check your credentials.';
      }
    } catch (e) {
      log('Login Exception: $e');
      return 'An unexpected error occurred.';
    }
  }

  void logout() async {
    await auth.signOut();
    notifyListeners();
  }
}
