import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/data/models/dashboard_stats.dart';
import '../../../core/data/models/purchase.dart';
import '../../../core/data/repositories/i_repository.dart';


class DashboardViewModel extends BaseViewModel {
  bool isDark = true;
  bool isCreateVisitLoading = false;

  final _repository = locator<IRepository>();
  final _navigationService = locator<NavigationService>();

  DashboardStats? stats;
  List<Purchase> recentTransactions = [];

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

  Future<void> init() async {
    await refresh();
  }

  Future<void> refresh() async {
    setBusy(true);
    try {
      stats = await _repository.getDashboardStats();
      recentTransactions = await _repository.getRecentTransactions();
      // Fetch top selling if needed
    } catch (e) {
      // Handle error
    } finally {
      setBusy(false);
    }
  }

  void viewAllTransactions() {
    _navigationService.navigateTo(Routes.purchaseView);
  }

  void viewLowStockItems() {
     _navigationService.navigateTo(Routes.storeView);
  }
}
