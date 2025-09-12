import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/data/models/user_model.dart';
import '../common/app_colors.dart';
import '../common/ui_helpers.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kcPrimaryColor.withOpacity(0.8),
            kcPrimaryColor.withOpacity(0.4),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage: user.profileImageUrl != null
                  ? NetworkImage(user.profileImageUrl!)
                  : null,
              child: user.profileImageUrl == null
                  ? Text(
                '${user.firstName[0]}${user.lastName[0]}',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kcPrimaryColor,
                ),
              )
                  : null,
            ),
            verticalSpaceSmall,
            Text(
              '${user.firstName} ${user.lastName}',
              style: GoogleFonts.redHatDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            verticalSpaceTiny,
            Text(
              user.professionalHeadline,
              style: GoogleFonts.redHatDisplay(
                fontSize: 14,
                color: Colors.white70,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpaceTiny,
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.white70),
                horizontalSpaceTiny,
                Text(
                  user.location,
                  style: GoogleFonts.redHatDisplay(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}