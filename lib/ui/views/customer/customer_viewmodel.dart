import 'package:stacked/stacked.dart';

import 'model/customer.dart';

class CustomerViewModel extends BaseViewModel {
  CustomerTab _tab = CustomerTab.all;
  String _query = '';

  final List<Customer> _customers = [
    const Customer(
      id: 'c1',
      name: 'Usman Ayuba',
      phone: '09060169686',
      address: 'Bassa village',
      isDebtor: false,
    ),
    const Customer(
      id: 'c2',
      name: 'Saidu musa',
      phone: '53566747',
      address: 'Bassa village',
      isDebtor: true,
    ),
    const Customer(
      id: 'c3',
      name: 'Abdulazeez Usman',
      phone: '09060169686',
      address: 'Bassa village',
      isDebtor: false,
    ),
  ];

  CustomerTab get tab => _tab;
  String get query => _query;

  int get allCount => _customers.length;
  int get debtorCount => _customers.where((c) => c.isDebtor).length;

  List<Customer> get visibleCustomers {
    Iterable<Customer> list =
    (_tab == CustomerTab.debtors) ? _customers.where((c) => c.isDebtor) : _customers;

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((c) =>
      c.name.toLowerCase().contains(q) || c.phone.toLowerCase().contains(q));
    }

    return list.toList(growable: false);
  }

  void setTab(CustomerTab value) {
    if (_tab == value) return;
    _tab = value;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void addCustomer({
    required String name,
    required String address,
    required String phone,
  }) {
    final item = Customer(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      address: address.trim(),
      phone: phone.trim(),
      isDebtor: false,
    );
    _customers.insert(0, item);
    notifyListeners();
  }
}
