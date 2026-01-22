import 'dart:ui' show lerpDouble;

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

    final height = lerpDouble(expandedHeight, collapsedHeight, tt)!;

    // Visual style shifts (tune freely)
    final radius = lerpDouble(22, 34, tt)!;

    // In the video it feels like the header is a floating pill with side margins,
    // and becomes slightly "more pill" when compact.
    final marginH = lerpDouble(14, 18, tt)!;
    final marginTop = lerpDouble(8, 6, tt)!;

    final padH = lerpDouble(16, 12, tt)!;

    final titleSize = lerpDouble(22, 20, tt)!;

    // Icon tile sizes tighten slightly
    final iconBox = lerpDouble(44, 40, tt)!;
    final iconRadius = lerpDouble(10, 12, tt)!;

    return Container(
      height: height + marginTop, // includes top breathing room
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height,
        margin: EdgeInsets.fromLTRB(marginH, marginTop, marginH, 0),
        padding: EdgeInsets.symmetric(horizontal: padH),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 16,
              offset: Offset(0, 8),
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
