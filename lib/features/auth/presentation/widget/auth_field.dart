import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final Icon prefixIcon;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final TextInputType textInputType;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    required this.prefixIcon,
    required this.focusNode,
    this.nextFocus,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        label: Text(hintText),
        prefixIcon: prefixIcon,
        labelStyle: const TextStyle(color: AppPallete.gradient2, fontSize: 18),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
      obscureText: isObscureText,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
    );
  }
}
