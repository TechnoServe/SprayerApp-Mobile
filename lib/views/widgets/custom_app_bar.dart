import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar{
  static AppBar appBar(BuildContext context, Function()? onTap) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: onTap,
        child: const Icon(
          FontAwesomeIcons.arrowLeft,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF00C013),
        size: 30.0,
      ),
    );
  }
}