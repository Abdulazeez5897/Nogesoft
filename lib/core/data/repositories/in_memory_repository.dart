import 'dart:async';
import 'package:nogesoft/core/data/models/business_profile.dart';
import 'package:nogesoft/core/data/models/customer.dart';
import 'package:nogesoft/core/data/models/dashboard_stats.dart';
import 'package:nogesoft/core/data/models/product.dart';
import 'package:nogesoft/core/data/models/purchase.dart';
import 'package:nogesoft/core/data/models/staff.dart';
import 'package:nogesoft/core/data/repositories/i_repository.dart';

/// A repository that holds data in memory and simulates network delays.
/// Useful for development and testing without a backend.
class InMemoryRepository implements IRepository {
  // --- SEED DATA ---

  // Dashboard Stats
  DashboardStats _stats = const DashboardStats(
    totalRevenue: 250000.0,
    totalSales: 124,
    totalCustomers: 45,
    lowStockItems: 3,
  );

  // Business Profile
  BusinessProfile _businessProfile = const BusinessProfile(
    id: 'biz_001',
    name: 'Nogesoft Store',
    phone: '+234 812 345 6789',
    email: 'info@nogesoft.com',
    address: '123 Tech Street, Lagos',
    branches: ['Lekki Branch', 'Ikeja Branch'],
  );

  // Products (Seed with some dummy data)
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'MacBook Pro M3',
      price: 2500000.0,
      stockQuantity: 10,
      sku: 'MAC-M3-001',
      description: 'Latest Apple laptop',
      dimensions: '30x21x1.5 cm',
    ),
    Product(
      id: 'p2',
      name: 'iPhone 15 Pro',
      price: 1800000.0,
      stockQuantity: 25,
      sku: 'IPH-15P-002',
      dimensions: '15x7x0.8 cm',
    ),
    Product(
      id: 'p3',
      name: 'Samsung S24 Ultra',
      price: 1950000.0,
      stockQuantity: 2, // Low stock
      sku: 'SAM-S24U-003',
      dimensions: '16x8x0.9 cm',
    ),
    Product(
      id: 'p4',
      name: 'Sony WH-1000XM5',
      price: 450000.0,
      stockQuantity: 15,
      sku: 'SNY-HP-004',
      dimensions: '20x18x8 cm',
    ),
  ];

  // Customers
  final List<Customer> _customers = [
    const Customer(
      id: 'c1',
      name: 'John Doe',
      phone: '08012345678',
      email: 'john@example.com',
      balance: 5000.0, // Owes money
    ),
    const Customer(
      id: 'c2',
      name: 'Jane Smith',
      phone: '08087654321',
      email: 'jane@example.com',
      balance: 0.0,
    ),
  ];

  // Staff
  final List<Staff> _staff = [
    const Staff(
      id: 's1',
      name: 'Admin User',
      role: 'Manager',
      isAdmin: true,
      phoneNumber: '080admin123',
    ),
    const Staff(
      id: 's2',
      name: 'Sales Rep 1',
      role: 'Sales',
      isAdmin: false,
      phoneNumber: '080sales001',
    ),
  ];

  // Suppliers
  final List<Supplier> _suppliers = [
    const Supplier(id: 'sup1', name: 'Amraya foam'),
    const Supplier(id: 'sup2', name: 'Vital foam'),
    const Supplier(id: 'sup3', name: 'ASB Foods LTD'),
    const Supplier(id: 'sup4', name: 'Dangote Groups'),
  ];

  // Purchases
  final List<Purchase> _purchases = [
    Purchase(
      id: 'pur1',
      invoiceNumber: 'INV-001',
      supplier: const Supplier(id: 'sup1', name: 'Amraya foam'),
      items: [
         PurchaseItem(
           product: Product(id: 'p1', name: 'MacBook Pro M3', price: 2500000, stockQuantity: 10, sku: 'MAC', dimensions: '30x21'),
           qty: 1,
           cost: 2000000,
           sell: 2500000,
         ),
      ],
      totalAmount: 2000000,
      amountPaid: 2000000,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Purchase(
      id: 'pur2',
      invoiceNumber: '46784',
      supplier: const Supplier(id: 'sup2', name: 'Vital foam'),
      items: [
        PurchaseItem(
          product: Product(id: 'p2', name: 'iPhone 15 Pro', price: 1800000, stockQuantity: 25, sku: 'IPH', dimensions: '15x7'),
          qty: 2,
          cost: 1500000,
          sell: 1800000,
        ),
      ],
      totalAmount: 3000000,
      amountPaid: 1500000, // Partial payment
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // --- METHODS ---

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<DashboardStats> getDashboardStats() async {
    await _simulateDelay();
    return _stats;
  }
  
  @override
  Future<List<Supplier>> getSuppliers() async {
    await _simulateDelay();
    return List.from(_suppliers);
  }

  @override
  Future<List<Product>> getProducts() async {
    await _simulateDelay();
    return List.from(_products);
  }

  @override
  Future<Product?> getProduct(String id) async {
    await _simulateDelay();
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    await _simulateDelay();
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _simulateDelay();
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _simulateDelay();
    _products.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Customer>> getCustomers() async {
    await _simulateDelay();
    return List.from(_customers);
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    await _simulateDelay();
    _customers.add(customer);
    _stats = _stats.copyWith(totalCustomers: _customers.length);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    await _simulateDelay();
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
    }
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await _simulateDelay();
    _customers.removeWhere((c) => c.id == id);
    _stats = _stats.copyWith(totalCustomers: _customers.length);
  }

  @override
  Future<List<Purchase>> getPurchases() async {
    await _simulateDelay();
    return List.from(_purchases);
  }

  @override
  Future<void> addPurchase(Purchase purchase) async {
    await _simulateDelay();
    _purchases.add(purchase);
  }

  @override
  Future<List<Purchase>> getRecentTransactions() async {
    await _simulateDelay();
    final sorted = List<Purchase>.from(_purchases)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  @override
  Future<List<Staff>> getStaffMembers() async {
    await _simulateDelay();
    return List.from(_staff);
  }

  @override
  Future<void> addStaff(Staff staff) async {
    await _simulateDelay();
    _staff.add(staff);
  }

  @override
  Future<void> deleteStaff(String id) async {
    await _simulateDelay();
    _staff.removeWhere((s) => s.id == id);
  }

  @override
  Future<BusinessProfile> getBusinessProfile() async {
    await _simulateDelay();
    return _businessProfile;
  }

  @override
  Future<void> updateBusinessProfile(BusinessProfile profile) async {
    await _simulateDelay();
    _businessProfile = profile;
  }
}
