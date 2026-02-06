import 'package:stacked/stacked.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/app.locator.dart';
import '../../../core/data/models/dashboard_stats.dart';
import '../../../core/data/models/purchase.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/repositories/i_repository.dart';
import '../../../core/services/app_shell_service.dart';


class DashboardViewModel extends BaseViewModel {
  bool isDark = true;
  bool isCreateVisitLoading = false;

  final _repository = locator<IRepository>();


  final _shellService = locator<AppShellService>();

  DashboardStats? stats;
  List<Purchase> recentTransactions = [];
  List<Product> topSellingProducts = [];

  // ---- Sales Analytics dropdown state ----
  final List<String> salesRanges = const [
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
  ];

  String _selectedSalesRange = 'Last 30 days';
  String get selectedSalesRange => _selectedSalesRange;

  List<FlSpot> salesSpots = const [FlSpot(0, 0)];
  List<String> salesBottomTitles = const [];

  Future<void> init() async {
    await refresh();
  }

  Future<void> refresh() async {
    setBusy(true);
    try {
      // 1. Fetch Stats & Transactions
      stats = await _repository.getDashboardStats();
      recentTransactions = await _repository.getRecentTransactions();

      // 2. Compute Top Selling Products (from purchases)
      final allPurchases = await _repository.getPurchases();
      _computeTopSelling(allPurchases);
      
      // 3. Compute Sales Analytics
      _computeSalesData(allPurchases);

    } catch (e) {
      // Handle error
      // print('Dashboard refresh error: $e');
    } finally {
      setBusy(false);
    }
  }

  void _computeTopSelling(List<Purchase> allPurchases) async {
      final productSales = <String, int>{}; // ProductId -> Qty

      for (var p in allPurchases) {
        for (var item in p.items) {
          productSales[item.product.id] = (productSales[item.product.id] ?? 0) + item.qty;
        }
      }

      // Sort by sales quantity
      final sortedKeys = productSales.keys.toList()
        ..sort((k1, k2) => productSales[k2]!.compareTo(productSales[k1]!));

      // Get top 5 product details
      final topIds = sortedKeys.take(5).toList();
      final topProducts = <Product>[];
      for (var id in topIds) {
        final product = await _repository.getProduct(id);
        if (product != null) topProducts.add(product);
      }
      topSellingProducts = topProducts;
  }

  void _computeSalesData(List<Purchase> allPurchases) {
    // Basic implementation: Aggregate by day for the selected range
    // Defaulting to last 7 days logic for simplicity in this iteration
    // Real implementation would parse 'selectedSalesRange'
    
    final now = DateTime.now();
    final Map<int, double> dailyTotals = {}; 
    const int daysToLookBack = 7;
    
    // Initialize with 0
    for (int i = 0; i < daysToLookBack; i++) {
      dailyTotals[i] = 0;
    }

    for (var p in allPurchases) {
      final diff = now.difference(p.date).inDays;
      if (diff >= 0 && diff < daysToLookBack) {
        // diff 0 = today, diff 6 = 7 days ago.
        // We want chart to go left(old) -> right(new).
        // Let's say index 0 = 6 days ago, index 6 = today.
        final index = (daysToLookBack - 1) - diff;
        dailyTotals[index] = (dailyTotals[index] ?? 0) + p.totalAmount;
      }
    }

    final spots = <FlSpot>[];
    final titles = <String>[];

    for (int i = 0; i < daysToLookBack; i++) {
        spots.add(FlSpot(i.toDouble(), dailyTotals[i]!));
        
        final date = now.subtract(Duration(days: (daysToLookBack - 1) - i));
        // Simple Wed 14 format
         // Manual formatting since we don't have explicit intl in this snippet context but we do in the file imports
        final weekday = _getShortWeekday(date.weekday);
        titles.add("$weekday ${date.day}");
    }
    
    salesSpots = spots;
    salesBottomTitles = titles;
    notifyListeners();
  }

  String _getShortWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  // Override setSalesRange to trigger refresh or recompute

  void setSalesRange(String value) {
    _selectedSalesRange = value;
    // For now, trigger refresh to recompute (in real app, separate fetch vs compute)
    refresh();
  }

  void viewAllTransactions() {
    _shellService.navigateToPurchases();
  }

  void viewLowStockItems() {
     _shellService.navigateToStore();
  }
}
