import 'package:chatapp/themes/dark_mode.dart';
import 'package:chatapp/themes/light_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightmode;
  ThemeData get themedata => _themeData;
  bool get isDrkMode => _themeData == darkmode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightmode) {
      themeData = darkmode;
    } else {
      themeData = lightmode;
    }
  }
}
