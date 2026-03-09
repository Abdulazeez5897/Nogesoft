import 'package:flutter/foundation.dart';

enum StaffRole { owner, admin, staff }
enum StaffStatus { active, inactive }

@immutable
class StaffMember {
  final String id;
  final String name;
  final String email;
  final StaffRole role;
  final StaffStatus status;
  final bool isAdmin;
  final String? avatarAssetOrUrl; // UI only; video shows an image but we’ll mock

  const StaffMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.isAdmin,
    this.avatarAssetOrUrl,
  });

  StaffMember copyWith({
    String? id,
    String? name,
    String? email,
    StaffRole? role,
    StaffStatus? status,
    bool? isAdmin,
    String? avatarAssetOrUrl,
  }) {
    return StaffMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      isAdmin: isAdmin ?? this.isAdmin,
      avatarAssetOrUrl: avatarAssetOrUrl ?? this.avatarAssetOrUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.label,
      'status': status.label,
      'isAdmin': isAdmin,
      'avatarAssetOrUrl': avatarAssetOrUrl,
    };
  }

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: StaffRole.values.firstWhere(
        (e) => e.label == json['role'],
        orElse: () => StaffRole.staff,
      ),
      status: StaffStatus.values.firstWhere(
        (e) => e.label == json['status'],
        orElse: () => StaffStatus.active,
      ),
      isAdmin: json['isAdmin'] as bool? ?? false,
      avatarAssetOrUrl: json['avatarAssetOrUrl'] as String?,
    );
  }
}

extension StaffRoleX on StaffRole {
  String get label {
    switch (this) {
      case StaffRole.owner:
        return 'owner';
      case StaffRole.admin:
        return 'admin';
      case StaffRole.staff:
        return 'staff';
    }
  }
}

extension StaffStatusX on StaffStatus {
  String get label {
    switch (this) {
      case StaffStatus.active:
        return 'active';
      case StaffStatus.inactive:
        return 'inactive';
    }
  }
}
