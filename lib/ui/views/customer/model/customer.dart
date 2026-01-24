import 'package:flutter/foundation.dart';

enum CustomerTab { all, debtors }

@immutable
class Customer {
  final String id;
  final String name;
  final String phone;
  final String address;
  final bool isDebtor;

  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.isDebtor,
  });

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    bool? isDebtor,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isDebtor: isDebtor ?? this.isDebtor,
    );
  }
}
