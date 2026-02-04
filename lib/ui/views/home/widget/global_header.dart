import 'dart:ui' as ui show lerpDouble, ImageFilter;

import 'package:flutter/material.dart';

class GlobalHeader extends StatelessWidget {
  /// 0.0 = expanded, 1.0 = collapsed
  final double t;

  /// Allows the shell to tune sizes without hardcoding inside the header.
  final double expandedHeight;
  final double collapsedHeight;

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenDrawer;

  const GlobalHeader({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onOpenDrawer,
    required this.t,
    required this.expandedHeight,
    required this.collapsedHeight,
  });

  @override
  Widget build(BuildContext context) {
    final tt = t.clamp(0.0, 1.0);

    final bg = isDarkMode ? const Color(0xFF0C1524) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0B1220);

    final height = ui.lerpDouble(expandedHeight, collapsedHeight, tt)!;

    // Visual style shifts
    // Expanded: margin 0, radius 0 (Full width)
    // Collapsed: margin 16, radius 30 (Floating pill)
    final radius = ui.lerpDouble(0, 30, tt)!;
    final marginH = ui.lerpDouble(0, 16, tt)!;
    final marginTop = ui.lerpDouble(0, 8, tt)!; // Push down slightly when floating

    final padH = ui.lerpDouble(20, 24, tt)!;

    // Title size
    final titleSize = ui.lerpDouble(24, 20, tt)!;

    // Icon tile sizes
    final iconBox = ui.lerpDouble(48, 40, tt)!;
    final iconRadius = ui.lerpDouble(12, 20, tt)!; // Square-ish to rounder

    // Transparency for blur effect
    // Fully opaque when expanded, slightly transparent when collapsed/floating
    final opacity = isDarkMode 
        ? ui.lerpDouble(1.0, 0.85, tt)! 
        : ui.lerpDouble(1.0, 0.90, tt)!;

    final bgColor = bg.withOpacity(opacity);

    return Container(
      height: height + marginTop, 
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        margin: EdgeInsets.fromLTRB(marginH, marginTop, marginH, 0),
        // Clip for blur and rounded corners
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10 * tt, sigmaY: 10 * tt),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: padH),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1 * tt),
                    blurRadius: 10 * tt,
                    offset: Offset(0, 4 * tt),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Nogesoft',
                    style: TextStyle(
                      color: textColor,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
        
                  _IconButton(
                    icon: isDarkMode
                        ? Icons.nights_stay_rounded
                        : Icons.wb_sunny_rounded,
                    color: const Color(0xFFFFD54A),
                    onTap: onToggleTheme,
                    isDarkMode: isDarkMode,
                    size: iconBox,
                    radius: iconRadius,
                  ),
        
                  const SizedBox(width: 10),
        
                  _IconButton(
                    icon: Icons.menu,
                    onTap: onOpenDrawer,
                    isDarkMode: isDarkMode,
                    size: iconBox,
                    radius: iconRadius,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;
  final bool isDarkMode;

  final double size;
  final double radius;

  const _IconButton({
    required this.icon,
    required this.onTap,
    required this.isDarkMode,
    required this.size,
    required this.radius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor =
    isDarkMode ? const Color(0xFF111C2E) : const Color(0xFFF1F3F6);
    final iconColor =
        color ?? (isDarkMode ? Colors.white : const Color(0xFF0B1220));

    return Material(
      color: tileColor,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
