class Staff {
  final String id;
  final String name;
  final String role; // 'admin', 'staff', 'manager'
  final bool isAdmin;
  final String photoUrl;
  final String phoneNumber;

  const Staff({
    required this.id,
    required this.name,
    this.role = 'staff',
    this.isAdmin = false,
    this.photoUrl = '',
    this.phoneNumber = '',
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'staff',
      isAdmin: json['isAdmin'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'isAdmin': isAdmin,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
    };
  }

  Staff copyWith({
    String? id,
    String? name,
    String? role,
    bool? isAdmin,
    String? photoUrl,
    String? phoneNumber,
  }) {
    return Staff(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      isAdmin: isAdmin ?? this.isAdmin,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
