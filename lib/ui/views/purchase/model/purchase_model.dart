import 'package:flutter/foundation.dart';

@immutable
class Supplier {
  final String id;
  final String name;

  const Supplier({required this.id, required this.name});
}

@immutable
class CatalogProduct {
  final String id;
  final String name;

  const CatalogProduct({required this.id, required this.name});
}

@immutable
class PurchaseItem {
  final CatalogProduct product;
  final int qty;
  final int cost;
  final int sell;

  const PurchaseItem({
    required this.product,
    required this.qty,
    required this.cost,
    required this.sell,
  });
}

@immutable
class Purchase {
  final String id;
  final String invoiceNumber;
  final Supplier supplier;
  final DateTime date;
  final int totalAmount;
  final int amountPaid;
  final List<PurchaseItem> items;

  const Purchase({
    required this.id,
    required this.invoiceNumber,
    required this.supplier,
    required this.date,
    required this.totalAmount,
    required this.amountPaid,
    required this.items,
  });

  int get balance => (totalAmount - amountPaid).clamp(0, totalAmount);
}
