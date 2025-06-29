import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderContainer extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color borderColor;
  final Color textColor;

  const HeaderContainer({
    Key? key,
    required this.title,
    this.imagePath = 'assets/images/header-image.png',
    this.borderColor = Colors.blue, // Replace with kcPrimaryColor
    this.textColor = Colors.white, // Replace with kcWhiteColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
