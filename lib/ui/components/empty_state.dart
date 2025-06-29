import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../common/ui_helpers.dart';


/// @author Usman Abdulazeez
/// email: abdulazeezusman732@@gmail.com
/// June, 2025
///


class EmptyState extends StatelessWidget {
  final String animation;
  final String label;

  const EmptyState({
    required this.animation,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/$animation", fit: BoxFit.cover, height: 300 ),
          verticalSpaceMedium,
          Text(
            label,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
