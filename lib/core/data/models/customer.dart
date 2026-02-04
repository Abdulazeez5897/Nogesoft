class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final double debt; // Positive means they owe us (debtor)
  final String address;

  const Customer({
    required this.id,
    required this.name,
    this.phone = '',
    this.email = '',
    this.debt = 0.0,
    this.address = '',
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      debt: (json['debt'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'debt': debt,
      'address': address,
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    double? debt,
    String? address,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      debt: debt ?? this.debt,
      address: address ?? this.address,
    );
  }
}
