import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class DateFormFieldWidget extends StatelessWidget {
  const DateFormFieldWidget({
    Key? key,
    required this.name,
    this.hintText,
    this.onChanged,
    this.controller,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.inputType = InputType.date,
    this.format = "dd/MM/yyyy",
  }) : super(key: key);

  final String name;
  final String? hintText;
  final Function(DateTime?)? onChanged;
  final TextEditingController? controller;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTime?)? validator;
  final InputType inputType;
  final String format;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      validator: validator,
      name: name,
      initialValue: initialValue,
      firstDate: firstDate,
      lastDate: lastDate,
      controller: controller,
      onChanged: onChanged,
      enabled: true,
      inputType: inputType,
      format: DateFormat(format),
      style: const TextStyle(color: Color(0xFF868080),),
      decoration: InputDecoration(
        hintText: hintText ?? "",
        hintStyle: const TextStyle(
          fontSize: 15.0,
          color: Color(0xFF868080),
        ),
        labelText: hintText,
        filled: true,
        fillColor: const Color(0xFFF6F5F5),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              100.0,
            ),
          ),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
