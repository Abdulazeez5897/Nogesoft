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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Gradient only in Dark Mode. Solid color in Light Mode.
          gradient: isDark
              ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F1B2D),
            ],
          )
              : null,
          color: isDark ? null : theme.scaffoldBackgroundColor,
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
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.35 : 0.05),
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
                                    color: theme.textTheme.titleLarge?.color,
                                  ),
                                ),
                                verticalSpaceTiny,
                                Text(
                                  'Manage your business in one place',
                                  style: GoogleFonts.redHatDisplay(
                                    fontSize: 15,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),

                                verticalSpaceLarge,

                                /// Email
                                TextField(
                                  controller: viewModel.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'you@business.com',
                                  ),
                                ),

                                verticalSpaceMedium,

                                /// Password
                                TextField(
                                  controller: viewModel.passwordController,
                                  obscureText: viewModel.obscurePassword,
                                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    suffixIcon: IconButton(
                                      onPressed: viewModel.togglePasswordVisibility,
                                      icon: Text(
                                        viewModel.obscurePassword ? '🙈' : '👁️',
                                        style: const TextStyle(fontSize: 20),
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
                                        side: BorderSide(
                                          color: isDark ? Colors.white54 : Colors.black45,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Text(
                                      'Remember me',
                                      style: TextStyle(
                                        color: isDark ? Colors.white70 : Colors.black54,
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
                          Center(
                            child: Text(
                              '© 2026 Nogesoft',
                              style: TextStyle(
                                color: isDark ? Colors.white38 : Colors.black38,
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
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();
}
