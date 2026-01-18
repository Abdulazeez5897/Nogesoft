import 'package:_247remotejobs/ui/views/profile/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/skill_chip.dart';

class EditProfileView extends StackedView<ProfileViewModel> {
  const EditProfileView({super.key});

  @override
  Widget builder(
      BuildContext context,
      ProfileViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: viewModel.navigateBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: viewModel.saveProfile,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(viewModel),
              verticalSpaceMedium,

              // Basic Information
              _buildBasicInfoSection(viewModel),
              verticalSpaceSmall,

              // Professional Information
              _buildProfessionalInfoSection(viewModel),
              verticalSpaceSmall,

              // Skills Section
              _buildSkillsSection(viewModel),
              verticalSpaceLarge,

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isBusy ? null : viewModel.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isBusy
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : Text(
                    'Save Changes',
                    style: GoogleFonts.redHatDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              verticalSpaceMedium,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(ProfileViewModel viewModel) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: kcLightGrey,
              backgroundImage: viewModel.profileImage != null
                  ? FileImage(viewModel.profileImage!) as ImageProvider
                  : (viewModel.user.profileImageUrl != null &&
                  viewModel.user.profileImageUrl!.isNotEmpty
                  ? NetworkImage(viewModel.user.profileImageUrl!) as ImageProvider
                  : null),
              child: viewModel.profileImage == null &&
                  (viewModel.user.profileImageUrl == null ||
                      viewModel.user.profileImageUrl!.isEmpty)
                  ? Icon(
                Icons.person_outline,
                size: 50,
                color: kcMediumGrey,
              )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: kcPrimaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  onPressed: viewModel.pickProfileImage,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
        verticalSpaceSmall,
        TextButton(
          onPressed: viewModel.pickProfileImage,
          child: Text(
            'Change Photo',
            style: GoogleFonts.redHatDisplay(
              color: kcPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(ProfileViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: GoogleFonts.redHatDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kcDarkGreyColor,
            ),
          ),
          verticalSpaceMedium,
          TextFormField(
            controller: viewModel.nameController, // Using your existing controller
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: kcBlackColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          verticalSpaceMedium,
          TextFormField(
            controller: viewModel.emailController, // Using your existing controller
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: kcBlackColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          verticalSpaceMedium,
          // Add phone field if you have it in your ViewModel
            TextFormField(
              controller: viewModel.phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kcBlackColor, width: 2),
                ),
              ),
            ),
          verticalSpaceMedium,
          // Add location field if you have it in your ViewModel
            TextFormField(
              controller: viewModel.locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., Lagos, Nigeria',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kcBlackColor, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoSection(ProfileViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Information',
            style: GoogleFonts.redHatDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kcDarkGreyColor,
            ),
          ),
          verticalSpaceMedium,
          // Add professional headline if you have it in your ViewModel
            TextFormField(
              controller: viewModel.professionalHeadlineController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Professional Headline',
                hintText: 'e.g., Senior Flutter Developer with 5+ years experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kcBlackColor, width: 2),
                ),
              ),
            ),
          verticalSpaceMedium,
          // Add portfolio field if you have it in your ViewModel
            TextFormField(
              controller: viewModel.portfolioController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: 'Portfolio URL (Optional)',
                hintText: 'https://yourportfolio.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: kcBlackColor, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(ProfileViewModel viewModel) {
    // Define some default skills to display
    final displaySkills = viewModel.skills ?? ['Flutter', 'Dart', 'Firebase', 'REST APIs'];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Skills',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kcDarkGreyColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: kcPrimaryColor),
                  onPressed: () => viewModel.showComingSoonSnackbar(),
                tooltip: 'Add Skill',
              ),
            ],
          ),
          verticalSpaceMedium,
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: displaySkills.map((skill) {
              return SkillChip(
                skill: skill,
                editable: false, // Set to false for read-only mode
              );
            }).toList(),
          ),
          if (displaySkills.isEmpty) ...[
            verticalSpaceMedium,
            Text(
              'No skills added. Tap the + button to add skills.',
              style: GoogleFonts.redHatDisplay(
                color: kcMediumGrey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}