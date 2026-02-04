import 'package:stacked/stacked.dart';

class AppShellService with ListenableServiceMixin {
  final ReactiveValue<int> _pageIndex = ReactiveValue<int>(0);
  int get pageIndex => _pageIndex.value;

  AppShellService() {
    listenToReactiveValues([_pageIndex]);
  }

  void setPage(int index) {
    _pageIndex.value = index;
    notifyListeners();
  }

  void navigateToHome() => setPage(0);
  void navigateToStore() => setPage(1);
  void navigateToReports() => setPage(2);
  void navigateToCustomers() => setPage(3);
  void navigateToPurchases() => setPage(4);
  void navigateToStaff() => setPage(5);
  void navigateToProfile() => setPage(6);
  void navigateToBusiness() => setPage(7);
}
