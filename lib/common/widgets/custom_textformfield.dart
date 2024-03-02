import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final bool isObscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool autoFocus;
  final Icon? suffixIcon;
  final bool enabled;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.enabled = true,
    this.isObscureText = false,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      autofocus: widget.autoFocus,
      controller: widget.controller,
      obscureText: widget.isObscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required field";
        }
        return null;
      },
    );
  }
}
