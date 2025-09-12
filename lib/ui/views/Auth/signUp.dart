import 'package:_247remotejobs/ui/common/app_colors.dart';
import 'package:_247remotejobs/ui/common/ui_helpers.dart';
import 'package:_247remotejobs/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import '../../components/custom_button_image.dart';
import 'auth_viewmodel.dart';

class SignUp extends StackedView<AuthViewModel> {
  const SignUp({super.key});

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
              // App Logo/Icon
              // Center(
              //   child: SvgPicture.asset(
              //     'assets/svg_icons/app_logo.svg',
              //     width: 80,
              //     height: 80,
              //   ),
              // ),
              // verticalSpaceMedium,

              // Header Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'Create Your Account',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kcDarkGreyColor,
                      ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      'No more guessing, apply with purpose and guidance',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kcMediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceLarge,

              // Form Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // First Name and Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: viewModel.firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              hintText: 'Enter First Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: kcBlackColor, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              prefixIcon: const Icon(Icons.person_outline, size: 20),
                              floatingLabelStyle: const TextStyle(color: kcBlackColor),
                            ),
                          ),
                        ),
                        horizontalSpaceSmall,
                        Expanded(
                          child: TextField(
                            controller: viewModel.lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              hintText: 'Enter Last Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: kcBlackColor, width: 2)
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              floatingLabelStyle: const TextStyle(color: kcBlackColor)
                            ),
                          ),
                        ),
                      ],
                     ),
                    verticalSpaceMedium,

                    // Email Address
                    TextField(
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter email Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kcBlackColor, width: 2)
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                        floatingLabelStyle: const TextStyle(color: kcBlackColor)
                      ),
                    ),
                    verticalSpaceMedium,

                    // Phone Number
                    TextField(
                      controller: viewModel.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kcBlackColor)
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                        floatingLabelStyle: const TextStyle(color: kcBlackColor)
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    verticalSpaceMedium,

                    // Password
                    TextField(
                      controller: viewModel.passwordController,
                      obscureText: viewModel.obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kcBlackColor, width: 2)
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: viewModel.togglePasswordVisibility,
                        ),
                        floatingLabelStyle: const TextStyle(color: kcBlackColor)
                      ),
                    ),
                    verticalSpaceMedium,

                    // Confirm Password
                    TextField(
                      controller: viewModel.confirmPasswordController,
                      obscureText: viewModel.obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kcBlackColor, width: 2)
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: viewModel.toggleConfirmPasswordVisibility,
                        ),
                        floatingLabelStyle: const TextStyle(color: kcBlackColor)
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceSmall,

              // Sign Up Button
              SubmitButton(
                isLoading: viewModel.isBusy,
                label: 'Sign Up',
                submit: viewModel.goto,
                color: kcBlackColor, // Use your brand color
              ),
              verticalSpaceMedium,

              // Divider with "Or" text
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: kcLightGrey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        color: kcMediumGrey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: kcLightGrey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,

              // Social Sign In Buttons
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
              verticalSpaceSmall,

              // Already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  GestureDetector(
                    onTap: viewModel.navigateToLogin,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: viewModel.isBusy ? Colors.grey : kcBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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