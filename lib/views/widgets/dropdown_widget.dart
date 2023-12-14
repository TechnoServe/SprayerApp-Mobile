import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DropdownWidget extends StatelessWidget {
  const DropdownWidget({
    Key? key,
    required this.name,
    required this.hintText,
    required this.items,
    this.initialValue,
    this.onChange,
    this.validator,
  }) : super(key: key);

  final String name;
  final String hintText;
  final List<dynamic> items;
  final Object? initialValue;
  final Function(Object?)? onChange;
  final String? Function(Object?)? validator;

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      validator: validator,
      initialValue: (items.isNotEmpty)
          ? (items.contains(initialValue) ? initialValue : null)
          : null,
      onChanged: onChange,
      name: name,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      style: const TextStyle(
        color: Color(0xFF868080),
      ),
      iconEnabledColor: const Color(
        0xFF868080,
      ),
      decoration: InputDecoration(
        hintText: hintText,
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
