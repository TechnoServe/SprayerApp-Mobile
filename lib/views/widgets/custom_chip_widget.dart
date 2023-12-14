import 'package:flutter/material.dart';
import 'package:sprayer_app/helpers/utils.dart';

class CustomChipWidget extends StatelessWidget {
  const CustomChipWidget({
    Key? key,
    required this.value,
    this.tileColor,
  }) : super(key: key);

  final String value;
  final Color? tileColor;

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 0.0,),
      label: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        textScaleFactor: 1.0,
      ),
      backgroundColor: (tileColor == null) ? Utils.primary : tileColor,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.black12,
          width: 0.2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
