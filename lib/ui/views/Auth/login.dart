import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/custom_button_image.dart';
import '../../components/submit_button.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => viewModel.navigateBack(),
              ),

              verticalSpaceLarge,

              // Header Section
              Text(
                'Welcome Back',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              verticalSpaceSmall,

              Text(
                'Sign in to continue your job search journey',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              verticalSpaceLarge,

              // Email Field
              TextField(
                controller: viewModel.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                ),
              ),
              verticalSpaceMedium,

              // Password Field
              TextField(
                controller: viewModel.passwordController,
                obscureText: viewModel.obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      viewModel.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: viewModel.togglePasswordVisibility,
                  ),
                ),
              ),
              // verticalSpaceSmall,
              //
              // // Forgot Password
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () => viewModel.navigateToForgotPassword(),
              //     child: Text(
              //       'Forgot Password?',
              //       style: TextStyle(
              //         color: kcPrimaryColor,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
              verticalSpaceLarge,

              //Login Button
              SubmitButton(
                isLoading: viewModel.isBusy,
                label: 'Sign In',
                submit: viewModel.login,
                color: kcBlackColor,
              ),
              verticalSpaceLarge,

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,

              // Social Login Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomSvgButton(
                      onPressed: viewModel.signUpWithGoogle,
                      svgPath: 'assets/svg_icons/google_Icon.svg',
                      label: 'Google',
                      backgroundColor: Colors.white,
                      borderColor: kcLightGrey,
                      textColor: kcDarkGreyColor,
                    ),
                  ),
                  horizontalSpaceSmall,
                  Expanded(
                    child: CustomSvgButton(
                      onPressed: viewModel.signUpWithApple,
                      svgPath: 'assets/svg_icons/apple_icon.svg',
                      label: 'Apple',
                      backgroundColor: kcWhiteColor,
                      borderColor: kcDarkGreyColor,
                      textColor: kcDarkGreyColor,
                    ),
                  ),
                ],
              ),
              verticalSpaceLarge,

              // Sign Up Redirect
              Center(
                child: GestureDetector(
                  onTap: () => viewModel.navigateToSignUp(),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.redHatDisplay(
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: kcBlackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();
}