import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../core/data/repositories/i_repository.dart';


import 'model/report_models.dart';


class ReportsViewModel extends BaseViewModel {
  static const Object refreshBusyKey = 'refreshReports';
  final _repository = locator<IRepository>();

  String _productQuery = '';

  List<ReportMetric> _metrics = [];
  List<ReportMetric> get metrics => List.unmodifiable(_metrics);

  List<ProductBreakdownItem> _products = [];
  
  List<double> _weeklySales = [];
  List<double> get weeklySales => _weeklySales;

  String get productQuery => _productQuery;

  bool get isRefreshing => busy(refreshBusyKey);

  String get statusMessage => _products.isEmpty ? 'No purchase report found.' : '';

  List<ProductBreakdownItem> get filteredProducts {
    final q = _productQuery.trim().toLowerCase();
    if (q.isEmpty) return List.unmodifiable(_products);
    return _products
        .where((p) => p.name.toLowerCase().contains(q))
        .toList(growable: false);
  }

  ProductBreakdownItem? get selectedProduct {
    final list = filteredProducts;
    if (list.isEmpty) return null;
    return list.first;
  }
  
  Future<void> init() async {
    await refresh();
  }

  void setProductQuery(String value) {
    _productQuery = value;
    notifyListeners();
  }

  Future<void> refresh() async {
    setBusyForObject(refreshBusyKey, true);
    try {
      // In real app, fetch from repository
      // _metrics = await _repository.getReportMetrics();
      // _products = await _repository.getProductBreakdown();
      // _weeklySales = await _repository.getWeeklySales();

      // Mocking for now as Repository interface might not have these specific methods yet
      await Future.delayed(const Duration(milliseconds: 650));
      
      _metrics = [
        const ReportMetric(type: ReportMetricType.bought, label: 'Bought', value: '10'),
        const ReportMetric(type: ReportMetricType.sold, label: 'Sold', value: '3'),
        const ReportMetric(type: ReportMetricType.remaining, label: 'Remaining', value: '7'),
        const ReportMetric(type: ReportMetricType.avgUnitCost, label: 'Avg Unit Cost', value: '₦3,500.00'),
        const ReportMetric(type: ReportMetricType.revenue, label: 'Revenue', value: '₦10,800'),
        const ReportMetric(type: ReportMetricType.cogs, label: 'COGS', value: '₦10,500'),
        const ReportMetric(type: ReportMetricType.profit, label: 'Profit', value: '₦300'),
        const ReportMetric(type: ReportMetricType.amountPaid, label: 'Amount Paid', value: '₦35,000'),
      ];

      _products = [
        const ProductBreakdownItem(
          name: 'Corn Flakes',
          bought: 10,
          sold: 3,
          remaining: 7,
          revenue: 10800,
          cogs: 10500,
          profit: 300,
          progress: 0.32,
        ),
        const ProductBreakdownItem(
          name: 'Sugar',
          bought: 20,
          sold: 8,
          remaining: 12,
          revenue: 24000,
          cogs: 20500,
          profit: 3500,
          progress: 0.45,
        ),
      ];
      
      _weeklySales = [3, 4, 3.5, 5, 4, 6, 7.5]; // Dummy sales data

    } catch (e) {
      // Handle error
    } finally {
      setBusyForObject(refreshBusyKey, false);
      notifyListeners();
    }
  }

  void onLatestPurchase() {}
  void onExportPdf() {}
  void onExportCsv() {}
}
