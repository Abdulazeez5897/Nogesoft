
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/ui_helpers.dart';


/// @author Usman Abdulazeez
/// email: abdulazeezusman732@@gmail.com
/// June, 2025
///


class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final Function() submit;
  final Color color;
  final Color textColor;
  final bool boldText;
  final IconData? icon;
  final Color? iconColor;
  final bool iconIsPrefix;
  final bool buttonDisabled;
  final double? borderRadius;
  final double? textSize;
  final String? svgFileName;
  final String? family;


  const SubmitButton(
      {Key? key,
        required this.isLoading,
        required this.label,
        required this.submit,
        required this.color,
        this.icon,
        this.iconColor,
        this.borderRadius = 10.15,
        this.textColor = Colors.white,
        this.boldText = false,
        this.iconIsPrefix = false,
        this.buttonDisabled = false,
        this.textSize = 16.0,
        this.svgFileName, this.family})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonDisabled
          ? null
          : isLoading
          ? () {}
          : submit,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 14.15),
          color: buttonDisabled
              ? Colors.grey[600]
              : isLoading
              ? color.withOpacity(0.7)
              : color,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          )
              : icon != null
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconIsPrefix
                  ? Row(
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? Colors.white,
                  ),
                  const SizedBox(width: 10),
                ],
              )
                  : const SizedBox(),


              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: textSize,
                  fontFamily: family ?? '',
                  fontWeight:
                  boldText ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              iconIsPrefix
                  ? const SizedBox()
                  : Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    icon,
                    color: iconColor ?? Colors.white,
                  ),
                ],
              )
            ],
          )
              : svgFileName != null ?
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/$svgFileName',
                  height: 20, // Icon size
                ),
                horizontalSpaceTiny,
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: textSize,
                    fontFamily: family ?? '',
                    fontWeight:
                    boldText ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ]
          )
              : Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
              fontWeight:
              boldText ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
