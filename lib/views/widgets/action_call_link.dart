import 'package:flutter/material.dart';
import 'package:sprayer_app/helpers/utils.dart';

class ActionCallLink extends StatelessWidget {
  const ActionCallLink({
    Key? key,
    required this.callText,
    required this.actionText,
    required this.pageRoute,
    this.stack = false,
  }) : super(key: key);

  final String callText;
  final String actionText;
  final Widget pageRoute;
  final bool stack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          actionText,
          style: TextStyle(
            fontSize: 15.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          ),
          onPressed: () {
            if (!stack) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => pageRoute,
                ),
                (route) => false,
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => pageRoute,
                ),
              );
            }
          },
          child: Text(
            callText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Utils.primary,
            ),
            textScaleFactor: 1.1,
          ),
        ),
      ],
    );
  }
}
