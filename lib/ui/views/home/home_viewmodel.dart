import 'package:stacked/stacked.dart';

// This should exist because main.dart uses it:
// import 'state.dart';  // (your main.dart imports it from lib root)
import '../../../state.dart';
import '../../../app/app.locator.dart';
import '../../../core/utils/local_storage.dart';
import '../../../core/utils/local_store_dir.dart';


enum AppShellPage {
  home,
  store,
  report,
  customer,
  purchase,
  staff,
  profile,
  business,
}

extension AppShellPageX on AppShellPage {
  String get title {
    switch (this) {
      case AppShellPage.home:
        return 'Home';
      case AppShellPage.store:
        return 'Store';
      case AppShellPage.report:
        return 'Reports';
      case AppShellPage.customer:
        return 'Customers';
      case AppShellPage.purchase:
        return 'Purchases';
      case AppShellPage.staff:
        return 'Staffs';
      case AppShellPage.profile:
        return 'My Profile';
      case AppShellPage.business:
        return 'My Business';
    }
  }
}

class HomeViewModel extends BaseViewModel {
  AppShellPage _page = AppShellPage.home;

  AppShellPage get page => _page;

  int get pageIndex => AppShellPage.values.indexOf(_page);

  bool get isDarkMode => uiMode.value == AppUiModes.dark;

  void setPage(AppShellPage value) {
    if (_page == value) return;
    _page = value;
    notifyListeners();
  }

  void toggleTheme() async {
    uiMode.value = isDarkMode ? AppUiModes.light : AppUiModes.dark;
    
    // Persist
    final storage = locator<LocalStorage>();
    await storage.save(LocalStorageDir.uiMode, isDarkMode ? "dark" : "light");

    notifyListeners(); // updates the icon immediately
  }
}
