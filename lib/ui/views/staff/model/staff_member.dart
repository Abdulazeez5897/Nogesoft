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
