import 'package:flutter/material.dart';

class TopElippsedEffect extends StatelessWidget {
  const TopElippsedEffect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned(
            left: -100,
            top: -100,
            child: Container(
              width: 200,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xff00C013),
                borderRadius:
                    BorderRadius.all(Radius.elliptical(200, 300)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: -150,
            child: Container(
              width: 200,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xff00C013),
                borderRadius:
                    BorderRadius.all(Radius.elliptical(200, 300)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}