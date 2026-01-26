import 'package:stacked/stacked.dart';

import 'model/report_models.dart';


class ReportsViewModel extends BaseViewModel {
  static const Object refreshBusyKey = 'refreshReports';

  String _productQuery = '';

  // Matches the video values exactly (initially)
  final List<ReportMetric> _metrics = const [
    ReportMetric(type: ReportMetricType.bought, label: 'Bought', value: '10'),
    ReportMetric(type: ReportMetricType.sold, label: 'Sold', value: '3'),
    ReportMetric(type: ReportMetricType.remaining, label: 'Remaining', value: '7'),
    ReportMetric(type: ReportMetricType.avgUnitCost, label: 'Avg Unit Cost', value: '₦3,500.00'),
    ReportMetric(type: ReportMetricType.revenue, label: 'Revenue', value: '₦10,800'),
    ReportMetric(type: ReportMetricType.cogs, label: 'COGS', value: '₦10,500'),
    ReportMetric(type: ReportMetricType.profit, label: 'Profit', value: '₦300'),
    ReportMetric(type: ReportMetricType.amountPaid, label: 'Amount Paid', value: '₦35,000'),
  ];

  final List<ProductBreakdownItem> _products = const [
    ProductBreakdownItem(
      name: 'Corn Flakes',
      bought: 10,
      sold: 3,
      remaining: 7,
      revenue: 10800,
      cogs: 10500,
      profit: 300,
      progress: 0.32,
    ),
    ProductBreakdownItem(
      name: 'Sugar',
      bought: 20,
      sold: 8,
      remaining: 12,
      revenue: 24000,
      cogs: 20500,
      profit: 3500,
      progress: 0.45,
    ),
    ProductBreakdownItem(
      name: 'Milk',
      bought: 6,
      sold: 6,
      remaining: 0,
      revenue: 9000,
      cogs: 7800,
      profit: 1200,
      progress: 1.0,
    ),
  ];

  List<ReportMetric> get metrics => List.unmodifiable(_metrics);

  String get productQuery => _productQuery;

  bool get isRefreshing => busy(refreshBusyKey);

  // Keep the “No purchase report found.” text as shown in video.
  String get statusMessage => 'No purchase report found.';

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
    return list.first; // video shows a single product breakdown at a time
  }

  void setProductQuery(String value) {
    _productQuery = value;
    notifyListeners();
  }

  Future<void> refresh() async {
    setBusyForObject(refreshBusyKey, true);
    // Mimic a realistic refresh (no UI hack timers; this is VM state)
    await Future<void>.delayed(const Duration(milliseconds: 650));
    setBusyForObject(refreshBusyKey, false);
    notifyListeners();
  }

  // Buttons exist in UI; video shows no extra behavior beyond being clickable.
  void onLatestPurchase() {}
  void onExportPdf() {}
  void onExportCsv() {}
}
