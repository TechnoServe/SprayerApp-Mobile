import 'package:flutter/material.dart';
import 'package:sprayer_app/helpers/utils.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size.fromWidth(w)),
        elevation: MaterialStateProperty.all<double>(0.0),
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 15.0)),
        backgroundColor: MaterialStateProperty.all<Color>(
          Utils.primary,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: const BorderSide(
              color: Utils.primary,
            ),
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          color: Utils.white,
        ),
        textScaleFactor: 1.0,
      ),
    );
  }
}
