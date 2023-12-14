import 'package:flutter/material.dart';
import 'package:sprayer_app/helpers/utils.dart';

class SplashStateProgress extends StatelessWidget {
  SplashStateProgress({Key? key, required this.splashValues}) : super(key: key);
  final String splashValues;

  final Map<String, String> splashStates = {
    "loading": "Please wait the system to download all files from the server.",
    "error": "Error occured. Please check your internet connection.",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utils.progress(
                    customColor: Utils.white,
                  ),
                  Text(
                    splashStates[splashValues].toString(),
                    style: const TextStyle(
                      fontSize: Utils.mediumFs,
                      color: Utils.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              child: Image.asset("assets/icon/smart_sprayer_icon.png"),
            ),
          ],
        ),
      ),
    );
  }
}
