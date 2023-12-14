import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    Key? key,
    required this.name,
    this.hintText,
    this.obscureText,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.keyBoard,
    this.maxLines,
    this.suffixIcon,
  }) : super(key: key);

  final String name;
  final String? hintText;
  final bool? obscureText;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType? keyBoard;
  final int? maxLines;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      maxLines: maxLines ?? 1,
      keyboardType: keyBoard ?? TextInputType.text,
      name: name,
      initialValue: initialValue,
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      validator: validator,
      style: const TextStyle(
        color: Color(0xFF868080),
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText ?? "",
        hintStyle: const TextStyle(
          fontSize: 15.0,
          color: Color(0xFF868080),
        ),
        labelText: hintText,
        filled: true,
        fillColor: const Color(0xFFF6F5F5),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
