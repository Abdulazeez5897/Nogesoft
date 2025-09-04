import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/submit_button.dart';
import 'otpVerificationViewModel.dart';


class OtpVerificationView extends StackedView<OtpVerificationViewModel> {
  final String email;

  const OtpVerificationView({super.key, required this.email});

  @override
  Widget builder(
      BuildContext context,
      OtpVerificationViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, // Card background
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Form(
                    key: viewModel.otpFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image/Illustration
                        if (!viewModel.otpSent)
                          Column(
                            children: [
                              // Image.asset(
                              //   "assets/images/email_verification.png",
                              //   height: 200,
                              //   width: 200,
                              // ),
                            ],
                          ),
                        verticalSpaceMedium,

                        // Title
                        Text(
                          viewModel.otpSent
                              ? "Otp Verification"
                              : "Verify Your Email",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.redHatDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        verticalSpaceSmall,

                        // Subtitle
                        Text(
                          viewModel.otpSent
                              ? "We need to verify your Otp to continue"
                              : "Your OTP would be sent to the Email\n The code will expire in 5 minutes",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.redHatDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        verticalSpaceSmall,

                        // Email address
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.redHatDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: kcPrimaryColor,
                          ),
                        ),
                        verticalSpaceLarge,

                        // OTP Input Fields (when OTP is sent)
                        if (viewModel.otpSent) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 45,
                                child: TextFormField(
                                  controller: viewModel.otpControllers[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 1 && index < 5) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            }),
                          ),
                          verticalSpaceMedium,

                          // Resend Code
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Didn't get the code? ",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              GestureDetector(
                                onTap: viewModel.isBusy ? null : viewModel.resendOTP,
                                child: Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: viewModel.isBusy ? Colors.grey : kcBlackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceSmall,

                          // Countdown Timer
                          if (viewModel.otpResendCooldown > 0)
                            Text(
                              'Resend available in ${viewModel.otpResendCooldown} seconds',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                        verticalSpaceLarge,

                        // Submit Button
                        SubmitButton(
                          isLoading: viewModel.isBusy,
                          label: viewModel.otpSent ? "Verify" : "Send OTP",
                          submit: () {
                            if (viewModel.otpFormKey.currentState!.validate()) {
                              viewModel.otpSent
                                  ? viewModel.verifyOTP()
                                  : viewModel.sendOTP();
                            }
                          },
                          color: kcBlackColor,
                        ),
                        verticalSpaceMedium,

                        // Back to Login
                        // if (!viewModel.otpSent)
                        //   TextButton(
                        //     onPressed: () => viewModel.navigateBack(),
                        //     child: Text(
                        //       "Back to Login",
                        //       style: TextStyle(
                        //         color: kcPrimaryColor,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  OtpVerificationViewModel viewModelBuilder(BuildContext context) => OtpVerificationViewModel();
}