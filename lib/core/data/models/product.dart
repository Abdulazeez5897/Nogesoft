  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stockQuantity;
  final String sku;
  final String dimensions; // e.g. "10x20x5"
  final DateTime? expiryDate;
  final String imageUrl;
  final String unit; // pcs, kg, ltr

  const Product({
    required this.id,
    required this.name,
    this.description = '',
    this.category = '',
    this.price = 0.0,
    this.stockQuantity = 0,
    this.sku = '',
    this.dimensions = '',
    this.expiryDate,
    this.imageUrl = '',
    this.unit = 'pcs',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      sku: json['sku'] as String? ?? '',
      dimensions: json['dimensions'] as String? ?? '',
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'] as String)
          : null,
      imageUrl: json['imageUrl'] as String? ?? '',
      unit: json['unit'] as String? ?? 'pcs',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stockQuantity': stockQuantity,
      'sku': sku,
      'dimensions': dimensions,
      'expiryDate': expiryDate?.toIso8601String(),
      'imageUrl': imageUrl,
      'unit': unit,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? stockQuantity,
    String? sku,
    String? dimensions,
    DateTime? expiryDate,
    String? imageUrl,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sku: sku ?? this.sku,
      dimensions: dimensions ?? this.dimensions,
      expiryDate: expiryDate ?? this.expiryDate,
      imageUrl: imageUrl ?? this.imageUrl,
      unit: unit ?? this.unit,
    );
  }
}
