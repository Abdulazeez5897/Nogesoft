import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl; // optional; can be null for placeholder

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
