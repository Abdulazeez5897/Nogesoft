import 'package:flutter/material.dart';
import '../../../core/enums/auth_type.dart';

class AuthView extends StatelessWidget {
  final AuthType authType;
  final int? initialIndex;
  final Key? key;

  const AuthView({
    required this.authType,
    this.initialIndex,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Auth type: $authType, Initial index: $initialIndex'),
      ),
    );
  }
}
