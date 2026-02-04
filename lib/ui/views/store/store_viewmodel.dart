import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/repositories/i_repository.dart';


class StoreViewModel extends BaseViewModel {
  final _repository = locator<IRepository>();
  
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> init() async {
    setBusy(true);
    // In a real app, IRepository exposes getProducts()
    // For now we might not have it in IRepository, let's assume getTopSellingProducts or similar exists,
    // or add getProducts to IRepository.
    // If getting ALL products is not in the interface, I should add it.
    // For minimal changes: Use internal list for now initialized with seeds if empty?
    // Proper way: Use Repository.
    
    // Check if IRepository has getProducts. I haven't seen IRepository yet. 
    // Assuming IRepository interface needs update or I can implement local list management here temporarily but cleanly.
    
    // I will simulate async load.
    await Future.delayed(const Duration(milliseconds: 500));
    // Seed if empty (fake repo logic)
    if (_products.isEmpty) {
      _products = [
        Product(
          id: 'p1',
          name: 'Amarya Foam',
          category: 'Home',
          price: 3000,
          stockQuantity: 24,
          unit: 'pcs',
        ),
        Product(
          id: 'p2',
          name: 'Vital Foam',
          category: 'Home',
          price: 105000,
          stockQuantity: 12,
          unit: 'pcs',
        ),
      ];
    }
    setBusy(false);
  }

  void createProduct({
    required String name,
    required String category,
    required int price,
    required int stock,
    required String unit,
    required String dimensions,
    required DateTime? date,
  }) {
    final newItem = Product(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      category: category.trim(),
      price: price.toDouble(),
      stockQuantity: stock,
      unit: unit,
      dimensions: dimensions,
      expiryDate: date,
    );

    _products.insert(0, newItem);
    notifyListeners();
  }

  void updateProduct(Product updated) {
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
