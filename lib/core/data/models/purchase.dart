import 'product.dart';

class Supplier {
  final String id;
  final String name;

  const Supplier({required this.id, required this.name});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class PurchaseItem {
  final Product product;
  final int qty;
  final int cost;
  final int sell;

  const PurchaseItem({
    required this.product,
    required this.qty,
    required this.cost,
    required this.sell,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      qty: json['qty'] as int? ?? 0,
      cost: json['cost'] as int? ?? 0,
      sell: json['sell'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'qty': qty,
    'cost': cost,
    'sell': sell,
  };
}

class Purchase {
  final String id;
  final String invoiceNumber;
  final Supplier supplier;
  final DateTime date;
  final int totalAmount;
  final int amountPaid;
  final List<PurchaseItem> items;
  final String status;

  const Purchase({
    required this.id,
    required this.invoiceNumber,
    required this.supplier,
    required this.date,
    required this.totalAmount,
    required this.amountPaid,
    required this.items,
    this.status = 'completed',
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'] as String? ?? '',
      invoiceNumber: json['invoiceNumber'] as String? ?? '',
      supplier: Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      totalAmount: json['totalAmount'] as int? ?? 0,
      amountPaid: json['amountPaid'] as int? ?? 0,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => PurchaseItem.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      status: json['status'] as String? ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'supplier': supplier.toJson(),
      'date': date.toIso8601String(),
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'items': items.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }

  Purchase copyWith({
    String? id,
    String? invoiceNumber,
    Supplier? supplier,
    DateTime? date,
    int? totalAmount,
    int? amountPaid,
    List<PurchaseItem>? items,
    String? status,
  }) {
    return Purchase(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      supplier: supplier ?? this.supplier,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      amountPaid: amountPaid ?? this.amountPaid,
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }
}
