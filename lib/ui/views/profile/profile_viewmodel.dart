import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:file_picker/file_picker.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/data/models/user_model.dart';

class ProfileViewModel extends BaseViewModel {
  List<Map<String, String>> applications = [];
  List<Map<String, String>> savedJobs = [];

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  final formKey = GlobalKey<FormState>();

  bool isDarkMode = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  // Mock user data - replace with real data from your backend
  User get user => User(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    professionalHeadline: 'Senior Flutter Developer with 5+ years of experience in building cross-platform mobile applications',
    location: 'Lagos, Nigeria',
    skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'Provider', 'Bloc', 'CI/CD'],
    experience: [
      Experience(
        position: 'Senior Flutter Developer',
        company: 'TechCorp Inc.',
        duration: '2022 - Present',
      ),
      Experience(
        position: 'Mid-level Flutter Developer',
        company: 'StartUp Solutions',
        duration: '2020 - 2022',
      ),
    ],
    education: [
      Education(
        degree: 'B.Sc. Computer Science',
        institution: 'University of Lagos',
        year: '2019',
      ),
    ],
    resumeUrl: 'https://example.com/resume.pdf',
    resumeUploadDate: 'October 15, 2024',
  );

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
    _snackbarService.showSnackbar(
      message: isDarkMode ? "Dark mode enabled" : "Light mode enabled",
    );
  }

  void changePassword() {
    _snackbarService.showSnackbar(message: "Change password tapped!");
  }

  void navigateToEditProfile() {
    _navigationService.navigateTo(Routes.editProfileView);
  }

  void navigateToSettings() {
    _navigationService.navigateTo(Routes.settingsView);
  }

  Future<void> uploadNewResume() async {
    setBusy(true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        // TODO: Implement resume upload to backend
        await _dialogService.showDialog(
          title: 'Resume Upload',
          description: 'Resume uploaded successfully!',
        );
        notifyListeners();
      }
    } catch (e) {
      await _dialogService.showDialog(
        title: 'Upload Failed',
        description: 'Failed to upload resume. Please try again.',
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> downloadResume() async {
    // TODO: Implement resume download
    await _dialogService.showDialog(
      title: 'Download',
      description: 'Resume download started...',
    );
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    setBusy(true);
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    setBusy(false);

    _snackbarService.showSnackbar(message: "Profile updated successfully!");
  }

  Future<void> loadApplications() async {
    setBusy(true);

    // Simulate API call or database fetch
    await Future.delayed(const Duration(seconds: 2));

    applications = [
      {
        "title": "Flutter Developer - Remote",
        "status": "Pending",
        "date": "2025-09-10",
      },
      {
        "title": "Backend Engineer - Contract",
        "status": "Accepted",
        "date": "2025-09-05",
      },
      {
        "title": "UI/UX Designer - Fulltime",
        "status": "Rejected",
        "date": "2025-08-20",
      },
    ];

    setBusy(false);
  }

  Future<void> logout() async {
    // TODO: call your AuthenticationService.logout()
    _snackbarService.showSnackbar(message: "Logged out!");
    _navigationService.clearStackAndShow(Routes.signUp);
  }

  Future<void> loadSavedJobs() async {
    setBusy(true);

    // Simulate API/database fetch
    await Future.delayed(const Duration(seconds: 1));

    savedJobs = [
      {"title": "Flutter Developer", "company": "RemoteTech Inc."},
      {"title": "Backend Engineer", "company": "CloudWorks Ltd."},
      {"title": "UI Designer", "company": "Pixel Labs"},
    ];

    setBusy(false);
  }

  void removeJob(int index) {
    savedJobs.removeAt(index);
    notifyListeners();
  }

  void viewApplicationHistory() {
    _navigationService.navigateTo(Routes.applicationsView);
  }

  void viewSavedJobs() {
    _navigationService.navigateTo(Routes.savedJobsView);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}