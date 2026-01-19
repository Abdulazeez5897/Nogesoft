import 'package:stacked/stacked.dart';

enum AnalyticsRange { daily, weekly, monthly, yearly }

class DashboardViewModel extends BaseViewModel {
  bool isDark = true;
  bool isCreateVisitLoading = false;

  // -----------------------------
  // 1) Period dropdown (Strings)
  // -----------------------------
  final List<String> periodRanges = const [
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
  ];

  String _selectedPeriodLabel = 'Last 30 days';
  String get selectedPeriodLabel => _selectedPeriodLabel;

  void setPeriodRange(String value) {
    _selectedPeriodLabel = value;
    notifyListeners();
  }

  // ----------------------------------------
  // 2) Analytics range selector (Enum)
  // ----------------------------------------
  final List<AnalyticsRange> analyticsRanges = AnalyticsRange.values;

  AnalyticsRange _selectedAnalyticsRange = AnalyticsRange.weekly;
  AnalyticsRange get selectedAnalyticsRange => _selectedAnalyticsRange;

  void onRangeChanged(AnalyticsRange newRange) {
    _selectedAnalyticsRange = newRange;
    notifyListeners();
  }

  // -----------------------------
  // UI Actions
  // -----------------------------
  void toggleThemeIcon() {
    isDark = !isDark;
    notifyListeners();
  }

  void setCreateVisitLoading(bool value) {
    isCreateVisitLoading = value;
    notifyListeners();
  }

  void refresh() {
    // TODO: later -> call APIs, re-fetch dashboard data
  }

  void openMenu() {
    // handled by Scaffold endDrawer
  }

  void viewAllTransactions() {
    // TODO: navigate to full transactions list
  }

  void viewLowStockItems() {
    // TODO: navigate to inventory/low stock list
  }
}
