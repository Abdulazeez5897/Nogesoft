import 'package:flutter/foundation.dart';

@immutable
class BusinessBranch {
  final String id;
  final String name;
  final String address;

  const BusinessBranch({
    required this.id,
    required this.name,
    required this.address,
  });

  BusinessBranch copyWith({
    String? name,
    String? address,
  }) {
    return BusinessBranch(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  factory BusinessBranch.fromJson(Map<String, dynamic> json) {
    return BusinessBranch(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
    );
  }
}

@immutable
class BusinessProfile {
  final String id;
  final String companyHeader;
  final String distributorName;
  final String authorizedTag;
  final String email;
  final String phone;
  final String headOfficeAddress;
  final String? logoUrl;
  final List<BusinessBranch> branches;

  const BusinessProfile({
    required this.id,
    required this.companyHeader,
    required this.distributorName,
    required this.authorizedTag,
    required this.email,
    required this.phone,
    required this.headOfficeAddress,
    this.logoUrl,
    required this.branches,
  });

  BusinessProfile copyWith({
    String? companyHeader,
    String? distributorName,
    String? authorizedTag,
    String? email,
    String? phone,
    String? headOfficeAddress,
    String? logoUrl,
    List<BusinessBranch>? branches,
  }) {
    return BusinessProfile(
      id: id,
      companyHeader: companyHeader ?? this.companyHeader,
      distributorName: distributorName ?? this.distributorName,
      authorizedTag: authorizedTag ?? this.authorizedTag,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      headOfficeAddress: headOfficeAddress ?? this.headOfficeAddress,
      logoUrl: logoUrl ?? this.logoUrl,
      branches: branches ?? this.branches,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyHeader': companyHeader,
      'distributorName': distributorName,
      'authorizedTag': authorizedTag,
      'email': email,
      'phone': phone,
      'headOfficeAddress': headOfficeAddress,
      'logoUrl': logoUrl,
      'branches': branches.map((e) => e.toJson()).toList(),
    };
  }

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'] as String,
      companyHeader: json['companyHeader'] as String,
      distributorName: json['distributorName'] as String,
      authorizedTag: json['authorizedTag'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      headOfficeAddress: json['headOfficeAddress'] as String,
      logoUrl: json['logoUrl'] as String?,
      branches: (json['branches'] as List<dynamic>?)
              ?.map((e) => BusinessBranch.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}
