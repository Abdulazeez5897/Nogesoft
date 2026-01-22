import 'package:flutter/foundation.dart';

@immutable
class StoreProduct {
  final String id;
  final String name;
  final String category;
  final int price; // in naira for now
  final int stock;
  final String dimension; // e.g. pcs

  const StoreProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.dimension,
  });

  bool get isLowStock => stock <= 3;

  StoreProduct copyWith({
    String? id,
    String? name,
    String? category,
    int? price,
    int? stock,
    String? dimension,
  }) {
    return StoreProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      dimension: dimension ?? this.dimension,
    );
  }
}
