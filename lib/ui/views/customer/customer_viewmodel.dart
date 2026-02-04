import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../core/data/repositories/i_repository.dart';


import 'model/customer.dart';

class CustomerViewModel extends BaseViewModel {
  CustomerTab _tab = CustomerTab.all;
  String _query = '';
  CustomerTab get tab => _tab;

  String _query = '';

  int get allCount => _customers.length;
  int get debtorCount => _customers.where((c) => c.debt > 0).length;

  List<Customer> get visibleCustomers {
    // 1. Filter by Tab
    Iterable<Customer> result = _customers;
    if (_tab == CustomerTab.debtors) {
      result = result.where((c) => c.debt > 0);
    }

    // 2. Filter by Query
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result.where((c) =>
          c.name.toLowerCase().contains(q) || c.phone.contains(q));
    }

    return result.toList();
  }
  
  Future<void> init() async {
    setBusy(true);
    // In real app: _customers = await _repository.getCustomers();
    // Simulate delay and seed if empty
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_customers.isEmpty) {
      // Temporary seed until Repository is fully wired with persistent DB
      _customers = [
        const Customer(
          id: '1',
          name: 'Ibrahim Sani',
          address: 'No 4, Kofar Ruwa',
          phone: '08012345678',
          debt: 0,
          lastPurchaseDate: null,
        ),
        const Customer(
          id: '2',
          name: 'Grace Oyelowo',
          address: 'Sabon Gari, Kano',
          phone: '09087654321',
          debt: 15000,
          lastPurchaseDate: null,
        ),
      ];
    }
    
    setBusy(false);
  }

  void setTab(CustomerTab tab) {
    _tab = tab;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> addCustomer({
    required String name,
    required String address,
    required String phone,
    double initialDebt = 0.0,
  }) async {
    setBusy(true);
    final newCustomer = Customer(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      address: address.trim(),
      phone: phone,
      debt: initialDebt, 
    );
    _customers.insert(0, item);
    notifyListeners();
  }
}
