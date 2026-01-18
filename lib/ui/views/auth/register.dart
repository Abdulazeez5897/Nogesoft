import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/outlinedSubmitButton.dart';
import '../../components/submit_button.dart';
import 'auth_viewmodel.dart';

class RegistrationView extends StackedView<AuthViewModel> {
  final String email;
  final String firstName;
  final String lastName;

  const RegistrationView({
    super.key,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

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
              // Progress Indicator
              _buildProgressIndicator(viewModel),
              verticalSpaceLarge,

              // Header
              Text(
                'Complete Your Profile',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kcDarkGreyColor,
                ),
              ),
              verticalSpaceSmall,
              Text(
                'Help employers find you with a complete profile',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 16,
                  color: kcMediumGrey,
                ),
              ),
              verticalSpaceLarge,

              // Main Content - Ternary Sections
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    // SECTION 1: BASIC PROFILE INFO
                    if (viewModel.registrationSection == 1) ...[
                      _buildProfileInfoSection(viewModel),
                      verticalSpaceLarge,
                      _buildNextButton('Continue', viewModel.nextSection),
                    ],

                    // SECTION 2: RESUME UPLOAD
                    if (viewModel.registrationSection == 2) ...[
                      _buildResumeSection(viewModel),
                      verticalSpaceLarge,
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: viewModel.previousSection,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: kcBlackColor),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  color: kcBlackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Expanded(
                            child: ElevatedButton(
                              onPressed: viewModel.resumeFile != null
                                  ? viewModel.nextSection
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kcBlackColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // SECTION 3: JOB PREFERENCES
                    if (viewModel.registrationSection == 3) ...[
                      _buildJobPreferences(viewModel),
                      verticalSpaceLarge,
                      Column(
                        children: [
                          OutlinedSubmitButton(
                            isLoading: false,
                            label: 'Back',
                            submit: viewModel.previousSection,
                            color: kcBlackColor,
                            textColor: kcBlackColor,
                            boldText: false,
                            borderRadius: 12,
                            borderWidth: 1,
                          ),
                          verticalSpaceSmall,
                          SubmitButton(
                            isLoading: viewModel.isBusy,
                            label: 'Complete Registration',
                            submit: () => viewModel.completeRegistration(
                              email: email,
                              firstName: firstName,
                              lastName: lastName,
                            ),
                            color: kcBlackColor,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              verticalSpaceMedium,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(AuthViewModel viewModel) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: viewModel.registrationSection / 3, // 33%, 66%, or 100%
          backgroundColor: kcLightGrey,
          valueColor: AlwaysStoppedAnimation<Color>(kcBlackColor),
          borderRadius: BorderRadius.circular(8),
        ),
        verticalSpaceSmall,
        Text(
          'Step ${viewModel.registrationSection} of 3: ${_getStepTitle(viewModel.registrationSection)}',
          style: GoogleFonts.redHatDisplay(
            fontSize: 14,
            color: kcMediumGrey,
          ),
        ),
      ],
    );
  }

  String _getStepTitle(int section) {
    switch (section) {
      case 1: return 'Profile Info';
      case 2: return 'Resume Upload';
      case 3: return 'Preferences';
      default: return 'Profile Setup';
    }
  }

  Widget _buildProfileInfoSection(AuthViewModel viewModel) {
    return Column(
      children: [
        // Professional Headline
        TextField(
          controller: viewModel.professionalHeadlineController,
          decoration: InputDecoration(
            labelText: 'Professional Headline*',
            hintText: 'e.g., Senior Flutter Developer',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kcBlackColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: const Icon(Icons.work_outline, size: 20),
            floatingLabelStyle: const TextStyle(color: kcBlackColor),
          ),
        ),
        verticalSpaceMedium,

        // Location
        TextField(
          controller: viewModel.locationController,
          decoration: InputDecoration(
            labelText: 'Where are you based?*',
            hintText: 'e.g., Lagos, Nigeria',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kcBlackColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
            floatingLabelStyle: const TextStyle(color: kcBlackColor),
          ),
        ),
        verticalSpaceMedium,

        // Experience Level
        DropdownButtonFormField<String>(
          value: viewModel.experienceLevel,
          decoration: InputDecoration(
            labelText: 'Experience Level*',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kcBlackColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: const Icon(Icons.timeline_outlined, size: 20),
            floatingLabelStyle: const TextStyle(color: kcBlackColor),
          ),
          items: const [
            DropdownMenuItem(value: 'entry', child: Text('Entry Level (0-2 years)')),
            DropdownMenuItem(value: 'mid', child: Text('Mid Level (2-5 years)')),
            DropdownMenuItem(value: 'senior', child: Text('Senior Level (5+ years)')),
            DropdownMenuItem(value: 'executive', child: Text('Executive Level')),
          ],
          onChanged: (value) => viewModel.setExperienceLevel(value!),
        ),
        verticalSpaceMedium,

        // Skills
        TextField(
          controller: viewModel.skillsController,
          decoration: InputDecoration(
            labelText: 'Skills*',
            hintText: 'e.g., Flutter, Dart, Firebase, REST APIs',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kcBlackColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: const Icon(Icons.code_outlined, size: 20),
            floatingLabelStyle: const TextStyle(color: kcBlackColor),
          ),
        ),
        verticalSpaceMedium,

        // Portfolio Link (Optional)
        TextField(
          controller: viewModel.portfolioController,
          decoration: InputDecoration(
            labelText: 'Portfolio Link (Optional)',
            hintText: 'e.g., https://yourportfolio.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kcBlackColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: const Icon(Icons.link_outlined, size: 20),
            floatingLabelStyle: const TextStyle(color: kcBlackColor),
          ),
        ),
      ],
    );
  }

  Widget _buildResumeSection(AuthViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Your Resume/CV*',
          style: GoogleFonts.redHatDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kcDarkGreyColor,
          ),
        ),
        verticalSpaceSmall,
        Text(
          'Employers will review your resume to learn about your experience and skills',
          style: GoogleFonts.redHatDisplay(
            fontSize: 14,
            color: kcMediumGrey,
          ),
        ),
        verticalSpaceMedium,

        GestureDetector(
          onTap: viewModel.pickResume,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                  color: viewModel.resumeFile != null ? kcBlackColor : kcLightGrey,
                  width: 2
              ),
              borderRadius: BorderRadius.circular(16),
              color: viewModel.resumeFile != null
                  ? kcBlackColor.withOpacity(0.1)
                  : Colors.grey[50],
            ),
            child: Column(
              children: [
                Icon(
                  viewModel.resumeFile != null
                      ? Icons.check_circle_outline
                      : Icons.cloud_upload_outlined,
                  size: 48,
                  color: viewModel.resumeFile != null ? kcBlackColor : kcMediumGrey,
                ),
                verticalSpaceMedium,
                Text(
                  viewModel.resumeFile != null
                      ? 'Resume Uploaded Successfully!'
                      : 'Tap to Upload Resume',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: viewModel.resumeFile != null ? kcBlackColor : kcDarkGreyColor,
                  ),
                ),
                verticalSpaceSmall,
                Text(
                  viewModel.resumeFile != null
                      ? viewModel.resumeFile!.name
                      : 'PDF, DOCX (Max 5MB)',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 14,
                    color: kcMediumGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (viewModel.resumeFile != null) ...[
                  verticalSpaceSmall,
                  Text(
                    '${(viewModel.resumeFile!.size / 1024).toStringAsFixed(1)} KB',
                    style: GoogleFonts.redHatDisplay(
                      fontSize: 12,
                      color: kcMediumGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        verticalSpaceSmall,

        if (viewModel.resumeFile != null)
          TextButton(
            onPressed: viewModel.removeResume,
            child: Text(
              'Remove File',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildJobPreferences(AuthViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Preferences',
          style: GoogleFonts.redHatDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kcDarkGreyColor,
          ),
        ),
        verticalSpaceSmall,
        Text(
          'Tell us what kind of opportunities you\'re looking for',
          style: GoogleFonts.redHatDisplay(
            fontSize: 14,
            color: kcMediumGrey,
          ),
        ),
        verticalSpaceMedium,

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildPreferenceChip('Remote Only', viewModel.remoteOnly, viewModel.toggleRemoteOnly),
            _buildPreferenceChip('Hybrid Possible', viewModel.hybridPossible, viewModel.toggleHybridPossible),
            _buildPreferenceChip('Full-Time', viewModel.fullTime, viewModel.toggleFullTime),
            _buildPreferenceChip('Part-Time', viewModel.partTime, viewModel.togglePartTime),
            _buildPreferenceChip('Contract', viewModel.contract, viewModel.toggleContract),
            _buildPreferenceChip('Freelance', viewModel.freelance, viewModel.toggleFreelance),
          ],
        ),
      ],
    );
  }

  Widget _buildNextButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kcBlackColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceChip(String label, bool selected, Function(bool) onChanged) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onChanged,
      backgroundColor: Colors.white,
      selectedColor: kcBlackColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: selected ? kcBlackColor : kcDarkGreyColor,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: selected ? kcBlackColor : kcLightGrey,
        width: 1,
      ),
      showCheckmark: false,
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();
}