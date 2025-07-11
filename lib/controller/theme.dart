// Flutter imports:
import 'package:flutter/material.dart';
import 'package:inshort_clone/common/utils/logger.dart';

// Package imports:
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkThemeOn = Hive.box('themeMode').get('isDarkModeOn') ?? false;

  void darkTheme(bool status) {
    isDarkThemeOn = status;

    final themeBox = Hive.box('themeMode');
    themeBox.put('isDarkModeOn', status);
    logMessage(themeBox.get('isDarkModeOn').toString());

    notifyListeners();
  }
}
