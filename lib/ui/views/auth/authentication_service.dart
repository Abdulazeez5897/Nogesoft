import 'dart:async';
import 'package:stacked/stacked.dart';

// User model
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });
}

// Authentication Service
class AuthenticationService with ReactiveServiceMixin {
  final ReactiveValue<User?> _currentUser = ReactiveValue<User?>(null);
  final ReactiveValue<bool> _isLoggedIn = ReactiveValue<bool>(false);

  AuthenticationService() {
    listenToReactiveValues([_currentUser, _isLoggedIn]);
  }

  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;

  // Simulate sign up with email and password
  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Validate input
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Simulate successful sign up
      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );

      _currentUser.value = newUser;
      _isLoggedIn.value = true;

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  // Add this method for Google Sign-In
  Future<User> signInWithGoogle() async {
    try {
      // Simulate API call delay for Google sign in
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful Google sign in
      final user = User(
        id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
        firstName: 'Google',
        lastName: 'User',
        email: 'googleuser@example.com',
        phone: '+1234567890',
      );

      _currentUser.value = user;
      _isLoggedIn.value = true;

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Add this method for Apple Sign-In (if you need it)
  Future<User> signInWithApple() async {
    try {
      // Simulate API call delay for Apple sign in
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful Apple sign in
      final user = User(
        id: 'apple_user_${DateTime.now().millisecondsSinceEpoch}',
        firstName: 'Apple',
        lastName: 'User',
        email: 'appleuser@example.com',
        phone: '+1234567890',
      );

      _currentUser.value = user;
      _isLoggedIn.value = true;

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser.value = null;
    _isLoggedIn.value = false;
  }

  // Check if user is logged in (for app startup)
  Future<bool> checkAuthStatus() async {
    // Simulate checking if user is already logged in (e.g., from stored token)
    await Future.delayed(const Duration(milliseconds: 500));
    return _isLoggedIn.value;
  }
}