import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import 'authentication_service.dart';

class AuthViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  // Text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> signUp() async {
    if (!_validateForm()) {
      return;
    }

    setBusy(true);

    try {
      await _authenticationService.signUp(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
      );

      // Navigate to home on success
      _navigationService.replaceWith(Routes.homeView);
    } catch (e) {
      _snackbarService.showSnackbar(message: e.toString());
    } finally {
      setBusy(false);
    }
  }

  void navigateToLogin() {
    _navigationService.back();
  }

  void signUpWithGoogle() async {
    setBusy(true);
    try {
      await _authenticationService.signInWithGoogle();
      _navigationService.replaceWith(Routes.homeView);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Google sign in failed: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  void signUpWithApple() async {
    setBusy(true);
    try {
      await _authenticationService.signInWithApple();
      _navigationService.replaceWith(Routes.homeView);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Apple sign in failed: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  bool _validateForm() {
    if (firstNameController.text.isEmpty) {
      _snackbarService.showSnackbar(message: 'First name is required');
      return false;
    }
    if (lastNameController.text.isEmpty) {
      _snackbarService.showSnackbar(message: 'Last name is required');
      return false;
    }
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      _snackbarService.showSnackbar(message: 'Please enter a valid email address');
      return false;
    }
    if (phoneController.text.isEmpty) {
      _snackbarService.showSnackbar(message: 'Phone number is required');
      return false;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      _snackbarService.showSnackbar(message: 'Password must be at least 6 characters');
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _snackbarService.showSnackbar(message: 'Passwords do not match');
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}