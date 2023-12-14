import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprayer_app/helpers/utils.dart';

class CardKpiWidget extends StatelessWidget {
  const CardKpiWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 0.0,
      ),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Utils.primary,
              Utils.primary,
              Utils.primary,
              Utils.primary,
            ],
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), // Adds a tit
                Stack(
                  children: List.generate(
                    2,
                    (index) => Container(
                      margin: EdgeInsets.only(left: (15 * index).toDouble()),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Colors.white54),
                    ),
                  ),
                ) // Adds a stack of two circular containers to the right of the title
              ],
            ),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
