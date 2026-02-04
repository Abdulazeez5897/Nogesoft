import '../models/dashboard_stats.dart';
import '../models/product.dart';
import '../models/purchase.dart'; // contains Supplier
import '../models/customer.dart';
import '../models/staff.dart';
import '../models/business_profile.dart';

abstract class IRepository {
  // Dashboard
  Future<DashboardStats> getDashboardStats();

  // Suppliers
  Future<List<Supplier>> getSuppliers();

  // Products
  Future<List<Product>> getProducts();
  Future<Product?> getProduct(String id);
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);

  // Customers
  Future<List<Customer>> getCustomers();
  Future<void> addCustomer(Customer customer);
  Future<void> updateCustomer(Customer customer);
  Future<void> deleteCustomer(String id);

  // Purchases
  Future<List<Purchase>> getPurchases();
  Future<void> addPurchase(Purchase purchase);
  Future<List<Purchase>> getRecentTransactions();

  // Staff
  Future<List<Staff>> getStaffMembers();
  Future<void> addStaff(Staff staff);
  Future<void> deleteStaff(String id);

  // Business
  Future<BusinessProfile> getBusinessProfile();
  Future<void> updateBusinessProfile(BusinessProfile profile);
}
