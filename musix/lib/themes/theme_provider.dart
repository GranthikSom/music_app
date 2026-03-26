import 'package:flutter/material.dart';
import 'package:flutter_application_1/themes/light_mode.dart';
import 'package:flutter_application_1/themes/dark_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightmode;

  get themeDate => _themeData;

  bool get isDarkMode => _themeData == darkmode;

  set themeData(ThemeData themedata) {
    _themeData = themedata;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightmode) {
      _themeData = darkmode;
    } else {
      _themeData = lightmode;
    }
    notifyListeners();
  }
}
