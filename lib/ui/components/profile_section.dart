import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/app_colors.dart';
import '../common/ui_helpers.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onEdit;
  final bool showEditButton;

  const ProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.onEdit,
    this.showEditButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: kcPrimaryColor,
                  ),
                  horizontalSpaceSmall,
                  Text(
                    title,
                    style: GoogleFonts.redHatDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kcDarkGreyColor,
                    ),
                  ),
                ],
              ),
              if (showEditButton && onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: onEdit,
                  color: kcMediumGrey,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 18,
                ),
            ],
          ),
          verticalSpaceSmall,
          const Divider(height: 1, color: kcLightGrey),
          verticalSpaceMedium,

          // Section Content
          child,
        ],
      ),
    );
  }
}