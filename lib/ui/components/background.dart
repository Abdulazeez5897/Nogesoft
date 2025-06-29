import 'package:flutter/material.dart';

import '../common/app_colors.dart';


class Background extends StatelessWidget {
  final List<Widget> children;

  const Background({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kcPrimaryColor,
        ),
        ...children
      ],
    );
  }
}
