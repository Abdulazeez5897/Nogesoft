import 'package:flutter/material.dart';
import '../../state.dart';
import '../common/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String? label;
  final String hint;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final Function? validator;
  final Widget? suffix;
  final Widget? leading;
  final bool obscureText;
  final TextInputType? inputType;
  final bool readOnly;
  final Function? onChanged;
  final TextInputAction? textInputAction;

  const TextFieldWidget({
    Key? key,
    this.label,
    this.validator,
    this.inputType,
    required this.hint,
    required this.controller,
    this.readOnly = false,
    this.obscureText = false,
    this.onChanged,
    this.leading,
    this.suffix,
    this.focusNode,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      readOnly: readOnly,
      controller: controller,
      onChanged: onChanged as void Function(String value)?,
      textInputAction: textInputAction ?? TextInputAction.done,
      cursorColor:
          uiMode.value == AppUiModes.light ? kcBlackColor : kcWhiteColor,
      style: TextStyle(
          color: uiMode.value == AppUiModes.light ? kcBlackColor : kcWhiteColor,
          fontSize: 14),
      validator: validator as String? Function(String?)?,
      obscureText: obscureText,
      keyboardType: inputType,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kcBlackColor.withOpacity(0.22)),
        ),
        labelText: hint,
        labelStyle: TextStyle(
            color:
                uiMode.value == AppUiModes.light ? kcBlackColor : kcWhiteColor,
            fontSize: 14),
        prefixIcon: leading == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: leading,
              ),
        suffixIcon: suffix == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: suffix,
              ),
      ),
    );
  }
}
