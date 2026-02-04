class DashboardStats {
  final double totalRevenue;
  final int totalSales;
  final int totalCustomers;
  final int lowStockItems;

  const DashboardStats({
    this.totalRevenue = 0.0,
    this.totalSales = 0,
    this.totalCustomers = 0,
    this.lowStockItems = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalSales: json['totalSales'] as int? ?? 0,
      totalCustomers: json['totalCustomers'] as int? ?? 0,
      lowStockItems: json['lowStockItems'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'totalSales': totalSales,
      'totalCustomers': totalCustomers,
      'lowStockItems': lowStockItems,
    };
  }

  DashboardStats copyWith({
    double? totalRevenue,
    int? totalSales,
    int? totalCustomers,
    int? lowStockItems,
  }) {
    return DashboardStats(
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalSales: totalSales ?? this.totalSales,
      totalCustomers: totalCustomers ?? this.totalCustomers,
      lowStockItems: lowStockItems ?? this.lowStockItems,
    );
  }
}
