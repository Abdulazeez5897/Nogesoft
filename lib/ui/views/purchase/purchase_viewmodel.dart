import 'package:stacked/stacked.dart';

import 'model/purchase_model.dart';


class PurchaseViewModel extends BaseViewModel {
  String _query = '';

  final List<Supplier> _suppliers = const [
    Supplier(id: 'sup1', name: 'Amraya foam'),
    Supplier(id: 'sup2', name: 'Vital foam'),
    Supplier(id: 'sup3', name: 'ASB Foods LTD'),
  ];

  final List<CatalogProduct> _catalog = const [
    CatalogProduct(id: 'p1', name: 'Corn Flakes'),
    CatalogProduct(id: 'p2', name: 'Sugar'),
    CatalogProduct(id: 'p3', name: 'Milk'),
  ];

  final List<Purchase> _purchases = [
    Purchase(
      id: 'pu1',
      invoiceNumber: '46784',
      supplier: const Supplier(id: 'sup2', name: 'Vital foam'),
      date: DateTime(2026, 1, 25),
      totalAmount: 20000,
      amountPaid: 50000,
      items: const [
        PurchaseItem(
          product: CatalogProduct(id: 'p2', name: 'Sugar'),
          qty: 1,
          cost: 20000,
          sell: 30000,
        ),
      ],
    ),
    Purchase(
      id: 'pu2',
      invoiceNumber: '123456',
      supplier: const Supplier(id: 'sup3', name: 'ASB Foods LTD'),
      date: DateTime(2026, 1, 25),
      totalAmount: 35000,
      amountPaid: 35000,
      items: const [
        PurchaseItem(
          product: CatalogProduct(id: 'p1', name: 'Corn Flakes'),
          qty: 1,
          cost: 35000,
          sell: 0,
        ),
      ],
    ),
  ];

  String get query => _query;
  List<Supplier> get suppliers => List.unmodifiable(_suppliers);
  List<CatalogProduct> get catalog => List.unmodifiable(_catalog);

  List<Purchase> get visiblePurchases {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.unmodifiable(_purchases);
    return _purchases
        .where((p) => p.invoiceNumber.toLowerCase().contains(q))
        .toList(growable: false);
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void addPurchase({
    required Supplier supplier,
    required String invoiceNumber,
    required int amountPaid,
    required List<PurchaseItem> items,
  }) {
    final total = items.fold<int>(0, (sum, it) => sum + (it.cost * it.qty));
    final purchase = Purchase(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      invoiceNumber: invoiceNumber.trim(),
      supplier: supplier,
      date: DateTime(2026, 1, 25), // video date
      totalAmount: total == 0 ? 28000 : total, // keeps video vibe even with mock
      amountPaid: amountPaid,
      items: items,
    );

    _purchases.insert(0, purchase);
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
    // Matches “Jan 25, 2026”
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
