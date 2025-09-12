import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/app_colors.dart';

class SkillChip extends StatelessWidget {
  final String skill;
  final VoidCallback? onRemove;
  final bool editable;

  const SkillChip({
    super.key,
    required this.skill,
    this.onRemove,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        skill,
        style: GoogleFonts.redHatDisplay(
          fontSize: 12,
          color: kcPrimaryColor,
        ),
      ),
      backgroundColor: kcPrimaryColor.withOpacity(0.1),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      deleteIcon: editable
          ? const Icon(Icons.close, size: 14, color: kcPrimaryColor)
          : null,
      onDeleted: editable ? onRemove : null,
    );
  }
}