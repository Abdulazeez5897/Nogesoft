import 'package:flutter/material.dart';

import '../common/app_colors.dart';

class AnimatedRedStrip extends StatefulWidget {
  @override
  _AnimatedRedStripState createState() => _AnimatedRedStripState();
}

class _AnimatedRedStripState extends State<AnimatedRedStrip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    /// 🔄 Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    /// 🎯 Moving the Red Strip Left & Right
    _positionAnimation = Tween<double>(begin: 0, end: 60).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _positionAnimation,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(left: _positionAnimation.value),
          child: Container(
            width: double.infinity,
            height: 5, // Full height of banner
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      },
    );
  }
}
