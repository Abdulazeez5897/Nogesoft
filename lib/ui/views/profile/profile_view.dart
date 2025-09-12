import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/profile_header.dart';
import '../../components/profile_section.dart';
import '../../components/skill_chip.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
      BuildContext context,
      ProfileViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: ProfileHeader(user: viewModel.user),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: viewModel.navigateToEditProfile,
                  tooltip: 'Edit Profile',
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: viewModel.navigateToSettings,
                  tooltip: 'Settings',
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Professional Summary
              ProfileSection(
                title: 'Professional Summary',
                icon: Icons.work_outline,
                child: Text(
                  viewModel.user.professionalHeadline.isNotEmpty
                      ? viewModel.user.professionalHeadline
                      : 'Add your professional summary to attract employers',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 14,
                    color: viewModel.user.professionalHeadline.isNotEmpty
                        ? kcDarkGreyColor
                        : kcMediumGrey,
                    fontStyle: viewModel.user.professionalHeadline.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ),
              verticalSpaceMedium,

              // Skills
              ProfileSection(
                title: 'Skills',
                icon: Icons.code_outlined,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: viewModel.user.skills.map((skill) {
                    return SkillChip(skill: skill);
                  }).toList(),
                ),
              ),
              verticalSpaceMedium,

              // Experience
              ProfileSection(
                title: 'Experience',
                icon: Icons.business_center_outlined,
                child: viewModel.user.experience.isNotEmpty
                    ? Column(
                  children: viewModel.user.experience.map((exp) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.work_history_outlined,
                          size: 20),
                      title: Text(
                        exp.position,
                        style: GoogleFonts.redHatDisplay(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${exp.company} • ${exp.duration}',
                        style: GoogleFonts.redHatDisplay(
                          fontSize: 12,
                          color: kcMediumGrey,
                        ),
                      ),
                    );
                  }).toList(),
                )
                    : Text(
                  'Add your work experience',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 14,
                    color: kcMediumGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              verticalSpaceMedium,

              // Education
              ProfileSection(
                title: 'Education',
                icon: Icons.school_outlined,
                child: viewModel.user.education.isNotEmpty
                    ? Column(
                  children: viewModel.user.education.map((edu) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.school_outlined, size: 20),
                      title: Text(
                        edu.degree,
                        style: GoogleFonts.redHatDisplay(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${edu.institution} • ${edu.year}',
                        style: GoogleFonts.redHatDisplay(
                          fontSize: 12,
                          color: kcMediumGrey,
                        ),
                      ),
                    );
                  }).toList(),
                )
                    : Text(
                  'Add your education background',
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 14,
                    color: kcMediumGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              verticalSpaceMedium,

              // Resume Section
              ProfileSection(
                title: 'Resume',
                icon: Icons.description_outlined,
                child: Column(
                  children: [
                    if (viewModel.user.resumeUrl != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.description_outlined, size: 20),
                        title: Text(
                          'Current Resume',
                          style: GoogleFonts.redHatDisplay(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Uploaded on ${viewModel.user.resumeUploadDate}',
                          style: GoogleFonts.redHatDisplay(
                            fontSize: 12,
                            color: kcMediumGrey,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.download_outlined, size: 20),
                          onPressed: () => viewModel.downloadResume(),
                          tooltip: 'Download Resume',
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: viewModel.uploadNewResume,
                      icon: const Icon(Icons.upload_outlined, size: 18),
                      label: const Text('Upload New Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kcPrimaryColor.withOpacity(0.1),
                        foregroundColor: kcPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceLarge,

              // Stats Section
              ProfileSection(
                title: 'Profile Stats',
                icon: Icons.analytics_outlined,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Applications', '12', Icons.send_outlined),
                    _buildStatItem('Interviews', '3', Icons.video_call_outlined),
                    _buildStatItem('Saved Jobs', '8', Icons.bookmark_outline),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.navigateToEditProfile,
        backgroundColor: kcPrimaryColor,
        child: const Icon(Icons.edit_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: kcPrimaryColor),
        verticalSpaceTiny,
        Text(
          value,
          style: GoogleFonts.redHatDisplay(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kcDarkGreyColor,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.redHatDisplay(
            fontSize: 12,
            color: kcMediumGrey,
          ),
        ),
      ],
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}