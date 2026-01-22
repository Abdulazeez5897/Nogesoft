import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../common/ui_helpers.dart';

class OutlinedSubmitButton extends StatelessWidget {
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
  final double borderWidth;

  const OutlinedSubmitButton({
    Key? key,
    required this.isLoading,
    required this.label,
    required this.submit,
    required this.color,
    this.icon,
    this.iconColor,
    this.borderRadius = 10.15,
    required this.textColor,
    this.boldText = false,
    this.iconIsPrefix = false,
    this.buttonDisabled = false,
    this.textSize = 16.0,
    this.svgFileName,
    this.family,
    this.borderWidth = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? color;

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
              ? Colors.grey[600]?.withOpacity(0.1)
              : isLoading
              ? color.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: buttonDisabled
                ? Colors.grey[600]!
                : isLoading
                ? color.withOpacity(0.5)
                : color,
            width: borderWidth,
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
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
                    color: iconColor ?? effectiveTextColor,
                  ),
                  const SizedBox(width: 10),
                ],
              )
                  : const SizedBox(),
              Text(
                label,
                style: TextStyle(
                  color: effectiveTextColor,
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
                    color: iconColor ?? effectiveTextColor,
                  ),
                ],
              )
            ],
          )
              : svgFileName != null
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/$svgFileName',
                height: 20,
                color: effectiveTextColor,
              ),
              horizontalSpaceTiny,
              Text(
                label,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontSize: textSize,
                  fontFamily: family ?? '',
                  fontWeight: boldText
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          )
              : Text(
            label,
            style: TextStyle(
              color: effectiveTextColor,
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