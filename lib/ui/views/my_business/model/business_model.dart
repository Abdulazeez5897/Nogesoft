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
  final List<BusinessBranch> branches;

  const BusinessProfile({
    required this.id,
    required this.companyHeader,
    required this.distributorName,
    required this.authorizedTag,
    required this.email,
    required this.phone,
    required this.headOfficeAddress,
    required this.branches,
  });

  BusinessProfile copyWith({
    String? companyHeader,
    String? distributorName,
    String? authorizedTag,
    String? email,
    String? phone,
    String? headOfficeAddress,
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
      branches: branches ?? this.branches,
    );
  }
}
