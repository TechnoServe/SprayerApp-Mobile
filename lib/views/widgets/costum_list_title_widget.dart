import 'package:flutter/material.dart';
import 'package:sprayer_app/helpers/utils.dart';

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    Key? key,
    required this.sinchronized,
    required this.title,
    this.subtitle,
    this.isEditable = false,
    this.isDisabled = false,
    this.onEditPressed,
    this.onDisablePressed,
    this.child,
    this.iconData,
    this.backgroundColor = Utils.secondary,
  }) : super(key: key);

  final String sinchronized;
  final String title;
  final String? subtitle;
  final bool isEditable;
  final bool isDisabled;
  final Function()? onEditPressed;
  final Function()? onDisablePressed;
  final Widget? child;
  final IconData? iconData;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.black12,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (sinchronized.isNotEmpty)
                      ? Text(
                          sinchronized,
                          style: const TextStyle(color: Utils.success),
                        )
                      : Container(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                    ),
                  ),
                  subtitle != null
                      ? Text(
                          subtitle!,
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 14.0,
                          ),
                        )
                      : Container(),
                  (child != null) ? child! : Container(),
                ],
              ),
            ),
          ),
          isEditable
              ? Container(
                  margin: const EdgeInsets.only(
                    right: 10.0,
                  ),
                  decoration: const BoxDecoration(
                      color: Color(0xFF00C013),
                      borderRadius: BorderRadius.all(Radius.circular(500))),
                  child: IconButton(
                    icon: Icon(
                      iconData ?? Icons.edit,
                      color: Utils.secondary,
                    ),
                    onPressed: onEditPressed,
                  ),
                )
              : Container(),
          isDisabled
              ? Container(
                  margin: const EdgeInsets.only(
                    right: 10.0,
                  ),
                  decoration: const BoxDecoration(
                      color: Utils.danger,
                      borderRadius: BorderRadius.all(Radius.circular(500))),
                  child: IconButton(
                    icon: Icon(
                      iconData ?? Icons.delete,
                      color: Utils.white,
                    ),
                    onPressed: onDisablePressed,
                  ),
                )
              : Container(),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              color: Color(0xFF00C013),
            ),
            width: 5,
            height: 100,
          ),
        ],
      ),
    );
  }
}
