import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
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

              // Registration Form
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

                    // Resume/CV Upload
                    _buildResumeSection(viewModel),
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
                    verticalSpaceMedium,

                    // Job Preferences
                    _buildJobPreferences(viewModel),
                  ],
                ),
              ),
              verticalSpaceLarge,

              // Complete Registration Button
              SubmitButton(
                isLoading: viewModel.isBusy,
                label: 'Complete Registration',
                submit: () => viewModel.completeRegistration(
                  email: email,
                  firstName: firstName,
                  lastName: lastName,
                ),
                color: kcPrimaryColor,
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
          value: 0.5, // 50% complete (after basic info)
          backgroundColor: kcLightGrey,
          valueColor: AlwaysStoppedAnimation<Color>(kcPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        verticalSpaceSmall,
        Text(
          'Step 2 of 2: Profile Details',
          style: GoogleFonts.redHatDisplay(
            fontSize: 14,
            color: kcMediumGrey,
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
          'Resume/CV*',
          style: GoogleFonts.redHatDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kcDarkGreyColor,
          ),
        ),
        verticalSpaceSmall,
        GestureDetector(
          onTap: viewModel.pickResume,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: kcLightGrey, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file_outlined,
                  color: kcPrimaryColor,
                  size: 24,
                ),
                horizontalSpaceSmall,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.resumeFile != null
                            ? viewModel.resumeFile!.name
                            : 'Upload your resume (PDF, DOCX)',
                        style: GoogleFonts.redHatDisplay(
                          fontSize: 14,
                          color: viewModel.resumeFile != null ? kcDarkGreyColor : kcMediumGrey,
                        ),
                      ),
                      if (viewModel.resumeFile != null)
                        Text(
                          '${(viewModel.resumeFile!.size / 1024).toStringAsFixed(1)} KB',
                          style: GoogleFonts.redHatDisplay(
                            fontSize: 12,
                            color: kcMediumGrey,
                          ),
                        ),
                    ],
                  ),
                ),
                if (viewModel.resumeFile != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: viewModel.removeResume,
                    color: Colors.red,
                  ),
              ],
            ),
          ),
        ),
        verticalSpaceTiny,
        Text(
          'Max file size: 5MB. Supported formats: PDF, DOCX',
          style: GoogleFonts.redHatDisplay(
            fontSize: 12,
            color: kcMediumGrey,
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
          'Job Preferences*',
          style: GoogleFonts.redHatDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kcDarkGreyColor,
          ),
        ),
        verticalSpaceSmall,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPreferenceChip('Remote Only', viewModel.remoteOnly, viewModel.toggleRemoteOnly),
            _buildPreferenceChip('Hybrid Possible', viewModel.hybridPossible, viewModel.toggleHybridPossible),
            _buildPreferenceChip('Full-Time', viewModel.fullTime, viewModel.toggleFullTime),
            _buildPreferenceChip('Part-Time', viewModel.partTime, viewModel.togglePartTime),
            _buildPreferenceChip('Contract', viewModel.contract, viewModel.toggleContract),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferenceChip(String label, bool selected, Function(bool) onChanged) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onChanged,
      backgroundColor: Colors.white,
      selectedColor: kcPrimaryColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: selected ? kcPrimaryColor : kcDarkGreyColor,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: selected ? kcPrimaryColor : kcLightGrey,
        width: 1,
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();
}