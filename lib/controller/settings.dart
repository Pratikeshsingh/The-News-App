// Flutter imports:
import 'package:flutter/material.dart';
import 'package:inshort_clone/common/utils/logger.dart';

// Package imports:
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  bool isDarkThemeOn = Hive.box('settingsBox').get('isDarkModeOn') ?? false;
  String activeLanguge = Hive.box('settingsBox').get('activeLang') ?? "English";
  String localeCode = "en";

  String getActiveLanguageCode() {
    final value = Hive.box('settingsBox').get('activeLang');
    switch (value) {
      case "हिंदी":
        return "hi";
      case "Nederlands":
        return "nl";
      default:
        return "en";
    }
  }

  String getActiveCountryCode() {
    final value = Hive.box('settingsBox').get('activeLang');
    if (value == "Nederlands") {
      return "NL";
    }
    return "IN";
  }

  void darkTheme(bool status) {
    isDarkThemeOn = status;

    final themeBox = Hive.box('settingsBox');
    themeBox.put('isDarkModeOn', status);
    logMessage(themeBox.get('isDarkModeOn').toString());

    notifyListeners();
  }

  void setLang(String value) {
    activeLanguge = value;

    final langBox = Hive.box('settingsBox');

    switch (value) {
      case "हिंदी":
        langBox.put('activeLang', "हिंदी");
        localeCode = "hi";
        notifyListeners();
        break;
      case "Nederlands":
        langBox.put('activeLang', "Nederlands");
        localeCode = "nl";
        notifyListeners();
        break;
      default:
        langBox.put('activeLang', "English");
        localeCode = "en";
        notifyListeners();
    }

    notifyListeners();
  }
}
