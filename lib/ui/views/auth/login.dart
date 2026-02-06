import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/submit_button.dart';
import '../../common/ui_helpers.dart';
import 'auth_viewmodel.dart';

class LoginView extends StackedView<AuthViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
      BuildContext context,
      AuthViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F1B2D),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          /// Push card to vertical center
                          const Spacer(),

                          /// Login Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111C2E),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login to Nogesoft',
                                  style: GoogleFonts.redHatDisplay(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                verticalSpaceTiny,
                                Text(
                                  'Manage your business in one place',
                                  style: GoogleFonts.redHatDisplay(
                                    fontSize: 15,
                                    color: Colors.white70,
                                  ),
                                ),

                                verticalSpaceLarge,

                                /// Email
                                TextField(
                                  controller:
                                  viewModel.emailController,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  style: const TextStyle(
                                      color: Colors.white),
                                  decoration: _inputDecoration(
                                    label: 'Email',
                                    hint: 'you@business.com',
                                  ),
                                ),

                                verticalSpaceMedium,

                                /// Password
                                TextField(
                                  controller:
                                  viewModel.passwordController,
                                  obscureText:
                                  viewModel.obscurePassword,
                                  style: const TextStyle(
                                      color: Colors.white),
                                  decoration: _inputDecoration(
                                    label: 'Password',
                                    hint:
                                    'Enter your password',
                                    suffixIcon: IconButton(
                                      onPressed: viewModel.togglePasswordVisibility,
                                      icon: Text(
                                        viewModel.obscurePassword ? '🙈' : '👁️',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                  verticalSpaceLarge,

                                  /// Remember Me
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: viewModel.rememberMe,
                                          onChanged: viewModel.toggleRememberMe,
                                          activeColor: Colors.green,
                                          side: const BorderSide(color: Colors.white54),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                        horizontalSpaceSmall,
                                      const Text(
                                        'Remember me',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),

                                  verticalSpaceLarge,

                                  SubmitButton(
                                    isLoading: viewModel.isBusy,
                                    label: 'Sign in',
                                    submit: viewModel.login,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            /// Footer stays at bottom
                            const Center(
                              child: Text(
                                '© 2026 Nogesoft',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

  @override
  void onViewModelReady(AuthViewModel viewModel) => viewModel.init();

  @override
  AuthViewModel viewModelBuilder(BuildContext context) =>
      AuthViewModel();
}

/// Dark input decoration
InputDecoration _inputDecoration({
  required String label,
  required String hint,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white38),
    filled: true,
    fillColor: const Color(0xFF0C1524),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
      const BorderSide(color: Colors.green),
    ),
    contentPadding:
    const EdgeInsets.symmetric(
        horizontal: 16, vertical: 14),
    suffixIcon: suffixIcon,
  );
}
