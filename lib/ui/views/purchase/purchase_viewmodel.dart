import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/purchase.dart';
import '../../../core/data/repositories/i_repository.dart';


class PurchaseViewModel extends BaseViewModel {
  final _repository = locator<IRepository>();
  String _query = '';

  List<Purchase> _purchases = [];
  List<Supplier> _suppliers = [];
  List<Product> _catalog = [];

  String get query => _query;
  List<Purchase> get purchases => _purchases;
  List<Supplier> get suppliers => _suppliers;
  List<Product> get catalog => _catalog;

  List<Purchase> get visiblePurchases {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _purchases;
    return _purchases
        .where((p) => p.invoiceNumber.toLowerCase().contains(q) || p.supplier.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> init() async {
    setBusy(true);
    // Concurrent fetch
    await Future.wait([
      _fetchPurchases(),
      _fetchSuppliers(),
      _fetchCatalog(),
    ]);
    setBusy(false);
  }
  
  Future<void> _fetchPurchases() async {
    _purchases = await _repository.getPurchases();
    // sort desc date
    _purchases.sort((a,b) => b.date.compareTo(a.date));
  }

  Future<void> _fetchSuppliers() async {
    _suppliers = await _repository.getSuppliers();
  }

  Future<void> _fetchCatalog() async {
    _catalog = await _repository.getProducts();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> addPurchase({
    required Supplier supplier,
    required String invoiceNumber,
    required int amountPaid,
    required List<PurchaseItem> items,
  }) async {
    setBusy(true);
    final total = items.fold<int>(0, (sum, it) => sum + (it.cost * it.qty));
    final purchase = Purchase(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      invoiceNumber: invoiceNumber.trim(),
      supplier: supplier,
      date: DateTime.now(),
      totalAmount: total,
      amountPaid: amountPaid,
      items: items,
    );

    _purchases.insert(0, purchase);
    await _repository.addPurchase(purchase);

    setBusy(false);
    notifyListeners();
  }

  String formatNaira(int value) {
    final s = value.abs().toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      b.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) b.write(',');
    }
    return '₦$b';
  }

  String formatDate(DateTime d) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
