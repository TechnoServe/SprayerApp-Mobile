import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sprayer_app/helpers/utils.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Utils.dark,
    primaryColor: Utils.light,
    colorScheme: const ColorScheme.dark(
      primary: Colors.black54,
    ),
    iconTheme: const IconThemeData(
      color: Utils.primary,
    ),
  );

  static final lightTheme = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.light,
    scaffoldBackgroundColor: Utils.light,
    primaryColor: Utils.dark,
    colorScheme: const ColorScheme.light(
      primary: Colors.black54,      
    ),
    iconTheme: const IconThemeData(
      color: Utils.primary,
    ),
  );
}
