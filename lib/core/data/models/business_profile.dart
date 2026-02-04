class BusinessProfile {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String logoUrl;
  final List<String> branches;

  const BusinessProfile({
    required this.id,
    required this.name,
    this.phone = '',
    this.email = '',
    this.address = '',
    this.logoUrl = '',
    this.branches = const [],
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      branches: (json['branches'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'logoUrl': logoUrl,
      'branches': branches,
    };
  }

  BusinessProfile copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? logoUrl,
    List<String>? branches,
  }) {
    return BusinessProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      branches: branches ?? this.branches,
    );
  }
}
