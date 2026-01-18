import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class DashboardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  bool isCreateVisitLoading = false;
  // Mock data (replace with API later)
  final int profileCompletion = 85;
  final int newJobsCount = 3;

  final List<JobItem> recommendedJobs = [
    JobItem(
      title: 'Flutter Developer',
      company: 'RemoteLabs',
      type: 'Full-time',
      location: 'Worldwide',
      salary: '\$3,500/mo',
    ),
    JobItem(
      title: 'Frontend Engineer',
      company: 'DevCloud',
      type: 'Contract',
      location: 'Remote',
      salary: '\$40/hr',
    ),
  ];

  void navigateToJobs() {
    _navigationService.navigateTo(Routes.jobsView);
  }

  void navigateToProfile() {
    _navigationService.navigateTo(Routes.editProfileView);
  }

  void navigateToApplications() {
    _navigationService.navigateTo(Routes.applicationsView);
  }
}

class JobItem {
  final String title;
  final String company;
  final String type;
  final String location;
  final String salary;

  JobItem({
    required this.title,
    required this.company,
    required this.type,
    required this.location,
    required this.salary,
  });
}
