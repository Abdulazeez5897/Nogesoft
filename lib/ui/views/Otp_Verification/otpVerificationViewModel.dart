import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class OtpVerificationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  // Text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());

  // Form key
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _otpSent = false;
  int otpResendCooldown = 0;
  Timer? _resendTimer;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get otpSent => _otpSent;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> sendOTP() async {
    setBusy(true);

    // Simulate sending OTP
    await Future.delayed(const Duration(seconds: 2));

    _otpSent = true;
    setBusy(false);
    notifyListeners();
  }

  Future<void> verifyOTP() async {
    // Get the complete OTP code
    String otpCode = otpControllers.map((controller) => controller.text).join();

    if (otpCode.length != 6) {
      _snackbarService.showSnackbar(message: 'Please enter a valid 6-digit code');
      return;
    }

    setBusy(true);

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 2));

    setBusy(false);

    // Navigate to home screen on success
    _navigationService.replaceWith(Routes.registrationView,
    arguments: RegistrationViewArguments(
        email: emailController.text, firstName: '', lastName: ''));
  }

  void resendOTP() {
    if (otpResendCooldown > 0) return;

    setBusy(true);

    // Simulate resend OTP
    Future.delayed(const Duration(seconds: 1), () {
      setBusy(false);
      _snackbarService.showSnackbar(message: 'New OTP code sent to your email');

      // Start cooldown timer (60 seconds)
      otpResendCooldown = 60;
      notifyListeners();

      _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        otpResendCooldown--;
        notifyListeners();

        if (otpResendCooldown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  // Future<void> signUp() async {
  //   if (!_validateForm()) {
  //     _snackbarService.showSnackbar(message: 'Please fill all fields correctly');
  //     return;
  //   }
  //
  //   setBusy(true);
  //
  //   try {
  //     // Your signup logic here
  //     await Future.delayed(const Duration(seconds: 2)); // Simulate API call
  //
  //     // Navigate to OTP screen after successful signup
  //     _navigationService.navigateTo(
  //       Routes.otpVerificationView,
  //       arguments: OtpVerificationViewArguments(email: emailController.text),
  //     );
  //   } catch (e) {
  //     _snackbarService.showSnackbar(message: 'Sign up failed: ${e.toString()}');
  //   } finally {
  //     setBusy(false);
  //   }
  // }

  void navigateToLogin() {
    _navigationService.back();
  }

  void navigateBack() {
    _navigationService.back();
  }

  bool _validateForm() {
    if (firstNameController.text.isEmpty) {
      return false;
    }
    if (lastNameController.text.isEmpty) {
      return false;
    }
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      return false;
    }
    if (phoneController.text.isEmpty) {
      return false;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
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
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }
}