

import 'dart:ui';

enum UserStatus { ACTIVE, INACTIVE, PENDING, DELETED, SUSPENDED }
enum Gender { MALE, FEMALE, OTHER }
enum ApprovalStatus { APPROVED, PENDING, REJECTED }
enum UserRoleName { ESTATE_RESIDENT, MASTER, GENERAL_MANAGER, FACILITY_MANAGER, SECURITY, REGULAR }
enum CodeTypeConstant { CHANGE_PASSWORD, SIGNUP }

class AppUser {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? otherName;
  String? houseNumber;
  String? houseDescription;
  Gender? gender;
  String? phone;
  bool? emailVerified;
  bool? phoneVerified;
  String? device;
  Picture? picture;
  Picture? proofOfAddress;
  String? code;
  Country? country;
  dynamic addressPOJO;
  dynamic createdBy;
  // List<Estate>? estates;
  List<dynamic>? organizations;
  List<UserRole>? roles;
  UserStatus? status;
  ApprovalStatus? approvalStatus;
  List<dynamic>? userDevicePojos;
  DateTime? createdAt;

  AppUser({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.otherName,
    this.houseNumber,
    this.houseDescription,
    this.gender,
    this.phone,
    this.emailVerified,
    this.phoneVerified,
    this.device,
    this.picture,
    this.proofOfAddress,
    this.code,
    this.country,
    this.addressPOJO,
    this.createdBy,
    // this.estates,
    this.organizations,
    this.roles,
    this.status,
    this.approvalStatus,
    this.userDevicePojos,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      otherName: json['otherName'],
      houseNumber: json['houseNumber'],
      houseDescription: json['houseDescription'],
      gender: json['gender'] != null
          ? Gender.values.firstWhere(
              (e) => e.name == json['gender'], orElse: () => Gender.OTHER)
          : null,
      phone: json['phone'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      device: json['device'],
      // picture: json['picture'] != null ? Picture.fromJson(json['picture']) : null,
      // proofOfAddress:
      // json['proofOfAddress'] != null ? Picture.fromJson(json['proofOfAddress']) : null,
      code: json['code'],
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
      addressPOJO: json['addressPOJO'],
      createdBy: json['createdBy'],
      // estates: (json['estates'] as List?)?.map((e) => Estate.fromJson(e)).toList(),
      organizations: json['organizations'],
      roles: (json['roles'] as List?)?.map((r) => UserRole.fromJson(r)).toList(),
      status: json['status'] != null
          ? UserStatus.values.firstWhere(
              (e) => e.name == json['status'], orElse: () => UserStatus.PENDING)
          : UserStatus.PENDING,
      approvalStatus: json['approvalStatus'] != null
          ? ApprovalStatus.values.firstWhere(
              (e) => e.name == json['approvalStatus'], orElse: () => ApprovalStatus.PENDING)
          : ApprovalStatus.PENDING,
      userDevicePojos: json['userDevicePojos'],
      createdAt:
      json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'otherName': otherName,
      'houseNumber': houseNumber,
      'houseDescription': houseDescription,
      'gender': gender?.name,
      'phone': phone,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'device': device,
      // 'picture': picture?.toJson(),
      // 'proofOfAddress': proofOfAddress?.toJson(),
      'code': code,
      'country': country?.toJson(),
      'addressPOJO': addressPOJO,
      'createdBy': createdBy,
      // 'estates': estates?.map((e) => e.toJson()).toList(),
      'organizations': organizations,
      'roles': roles?.map((r) => r.toJson()).toList(),
      'status': status?.name,
      'approvalStatus': approvalStatus?.name,
      'userDevicePojos': userDevicePojos,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

}

class UserRole {
  String? name;
  int? id;
  List<dynamic>? permissions;

  UserRole({this.name, this.id, this.permissions});

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      name: json['name'],
      id: json['id'],
      permissions: json['permissions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'permissions': permissions,
    };
  }

}

class Country {
  int? id;
  String name;
  String? currency;
  String? phone;
  String capital;
  String? continent;
  String? code;
  String? code3;

  Country({
    this.id,
    required this.name,
    this.currency,
    this.phone,
    required this.capital,
    this.continent,
    this.code,
    this.code3,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'] ?? '',
      currency: json['currency'],
      phone: json['phone'],
      capital: json['capital'] ?? '',
      continent: json['continent'],
      code: json['code'],
      code3: json['code3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currency': currency,
      'phone': phone,
      'capital': capital,
      'continent': continent,
      'code': code,
      'code3': code3,
    };
  }
}

class Code {
  int? id;
  String code;
  DateTime? expiresIn;
  CodeTypeConstant? type;

  Code({
    this.id,
    required this.code,
    this.expiresIn,
    this.type,
  });

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      id: json['id'],
      code: json['code'] ?? '',
      expiresIn: json['expiresin'] != null
          ? DateTime.tryParse(json['expiresin'])
          : null,
      type: json['type'] != null
          ? CodeTypeConstant.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
        orElse: () => CodeTypeConstant.SIGNUP,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'expiresin': expiresIn?.toIso8601String(),
      'type': type?.toString().split('.').last,
    };
  }
}