import 'package:file_picker/file_picker.dart';
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
  final professionalHeadlineController = TextEditingController();
  final locationController = TextEditingController();
  final skillsController = TextEditingController();
  final portfolioController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String experienceLevel = 'mid';
  PlatformFile? resumeFile;
  int _registrationSection = 1;

  int get registrationSection => _registrationSection;
  bool remoteOnly = true;
  bool hybridPossible = false;
  bool fullTime = true;
  bool partTime = false;
  bool contract = false;
  bool freelance = false;

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

  void navigateBack() {
    _navigationService.back();
  }

  void setExperienceLevel(String level) {
    experienceLevel = level;
    notifyListeners();
  }

  void nextSection() {
    if (_registrationSection < 3) {
      _registrationSection++;
      notifyListeners();
    }
  }

  void previousSection() {
    if (_registrationSection > 1) {
      _registrationSection--;
      notifyListeners();
    }
  }

  Future<void> goto() async {
    await _navigationService.navigateTo(
      Routes.otpVerificationView,
      arguments: OtpVerificationViewArguments(
        email: emailController.text,
      ),
    );
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
      _navigationService.replaceWith(
        Routes.otpVerificationView,
        arguments: OtpVerificationViewArguments(
          email: emailController.text,
        ),
      );
    } catch (e) {
      _snackbarService.showSnackbar(message: e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> completeRegistration({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    // Validation
    if (professionalHeadlineController.text.isEmpty ||
        locationController.text.isEmpty ||
        skillsController.text.isEmpty ||
        resumeFile == null) {
      _snackbarService.showSnackbar(message: 'Please fill all required fields');
      return;
    }

    setBusy(true);

    try {
      // Upload resume and complete registration
      await Future.delayed(const Duration(seconds: 3)); // Simulate API call

      _snackbarService.showSnackbar(message: 'Registration completed successfully!');

      // Navigate to login
      _navigationService.clearStackAndShow(Routes.loginView);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Registration failed: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }


  Future<void> pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null) {
        resumeFile = result.files.first;
        notifyListeners();
      }
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Error picking file: ${e.toString()}');
    }
  }

  void removeResume() {
    resumeFile = null;
    notifyListeners();
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      _snackbarService.showSnackbar(message: 'Please enter a valid email address');
      return;
    }

    if (passwordController.text.isEmpty) {
      _snackbarService.showSnackbar(message: 'Please enter your password');
      return;
    }

    setBusy(true);

    try {
      // Simulate login API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to home screen on success
      _navigationService.replaceWith(Routes.homeView);
    } catch (e) {
      _snackbarService.showSnackbar(message: 'Login failed: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  // void navigateToForgotPassword() {
  //   _navigationService.navigateTo(Routes.forgotPasswordView);
  // }

  void navigateToSignUp() {
    _navigationService.navigateTo(Routes.signUp);
  }

  void navigateToLogin() {
    _navigationService.navigateTo(Routes.loginView);
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

  void toggleRemoteOnly(bool value) {
    remoteOnly = value;
    if (value) hybridPossible = false;
    notifyListeners();
  }

  void toggleHybridPossible(bool value) {
    hybridPossible = value;
    if (value) remoteOnly = false;
    notifyListeners();
  }

  void toggleFullTime(bool value) => fullTime = value;
  void togglePartTime(bool value) => partTime = value;
  void toggleContract(bool value) => contract = value;
  void toggleFreelance(bool value) => freelance = value;

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