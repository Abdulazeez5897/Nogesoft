import 'package:stacked/stacked.dart';

import 'model/store_product.dart';


class StoreViewModel extends BaseViewModel {
  final List<StoreProduct> _products = [
    StoreProduct(
      id: 'p1',
      name: 'Amarya Foam',
      category: 'Home',
      price: 3000,
      stock: 24,
      dimension: 'pcs',
    ),
    StoreProduct(
      id: 'p2',
      name: 'Vital Foam',
      category: 'Home',
      price: 105000,
      stock: 12,
      dimension: 'pcs',
    ),
  ];

  List<StoreProduct> get products => List.unmodifiable(_products);

  void createProduct({
    required String name,
    required String category,
    required int price,
    required int stock,
    required String dimension,
  }) {
    final newItem = StoreProduct(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      category: category.trim(),
      price: price,
      stock: stock,
      dimension: dimension,
    );

    _products.insert(0, newItem);
    notifyListeners();
  }

  void updateProduct(StoreProduct updated) {
    final idx = _products.indexWhere((p) => p.id == updated.id);
    if (idx == -1) return;
    _products[idx] = updated;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
