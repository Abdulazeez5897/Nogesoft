import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {
  bool isDark = true;
  bool isCreateVisitLoading = false;

  // ---- Sales Analytics dropdown state ----
  final List<String> salesRanges = const [
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
  ];

  String _selectedSalesRange = 'Last 30 days';
  String get selectedSalesRange => _selectedSalesRange;

  void setSalesRange(String value) {
    _selectedSalesRange = value;
    notifyListeners();
  }

  // ---- UI actions ----
  void toggleThemeIcon() {
    isDark = !isDark;
    notifyListeners();
  }

  void setCreateVisitLoading(bool value) {
    isCreateVisitLoading = value;
    notifyListeners();
  }

  void refresh() {
    // later: call APIs, re-fetch dashboard data
    notifyListeners();
  }

  void viewAllTransactions() {
    // TODO: navigate
  }

  void viewLowStockItems() {
    // TODO: navigate
  }
}
