import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.maxLines,
    this.controller,
    this.icon,
    this.focusNode,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.keyboardType,
    this.obscureText = false,
    required this.hint,
    required this.labelText,
  }) : super(key: key);

  final String? initialValue;
  final String hint;
  final String labelText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final Icon? icon;
  final TextEditingController? controller;
  final AutovalidateMode autoValidateMode;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      autovalidateMode: autoValidateMode,
      cursorColor: Colors.grey,
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: hint,
        prefixIcon: icon,
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: textDefault,
        floatingLabelStyle: textDefault,
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: textDefault,
    );
  }
}
