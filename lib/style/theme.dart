// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:inshort_clone/style/colors.dart';

final ThemeData kDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xff222222),
  primaryColor: AppColor.accent,
  colorScheme: ColorScheme.dark(
    primary: AppColor.accent,
    secondary: AppColor.accent,
    error: AppColor.error,
  ),
  appBarTheme: AppBarTheme(
    color: Color(0xff333333),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    iconTheme: IconThemeData(
      color: AppColor.accent,
    ),
  ),
  iconTheme: IconThemeData(
    color: AppColor.accent,
  ),
  fontFamily: "Montserrat",
);

final ThemeData kLightThemeData = ThemeData(
  canvasColor: AppColor.background,
  colorScheme: ColorScheme.light(
    primary: AppColor.accent,
    secondary: AppColor.accent,
    error: AppColor.error,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColor.primaryVariant,
  ),
  scaffoldBackgroundColor: Colors.white,
  brightness: Brightness.light,
  iconTheme: IconThemeData(
    color: AppColor.accent,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    iconTheme: IconThemeData(
      color: AppColor.accent,
    ),
  ),
  fontFamily: "Montserrat",
);
