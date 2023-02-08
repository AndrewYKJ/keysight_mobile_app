import 'package:flutter/material.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';

class ThemeClass extends ChangeNotifier {
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.appPrimaryBlack(),
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appPrimaryBlack(),
      foregroundColor: AppColors.appPrimaryBlack(),
    ),
    dataTableTheme: DataTableThemeData(
      decoration: BoxDecoration(color: AppColors.appBlackLight()),
    ),
  );
  late ThemeData _selectedTheme;
  late bool isDarkTheme;
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColorsLightMode.appPrimaryBlack(),
    colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsLightMode.appPrimaryBlack(),
      foregroundColor: AppColorsLightMode.appPrimaryBlack(),
    ),
    dataTableTheme: DataTableThemeData(
      decoration: BoxDecoration(color: AppColorsLightMode.appBlackLight()),
    ),
  );

  ThemeClass(bool darkThemeOn) {
    _selectedTheme = darkThemeOn ? darkTheme : lightTheme;
    isDarkTheme = darkThemeOn;
  }

  Future<void> swapTheme() async {
    if (_selectedTheme == darkTheme) {
      _selectedTheme = lightTheme;
      AppCache.setThemeValue(false);
      isDarkTheme = false;
    } else {
      _selectedTheme = darkTheme;
      AppCache.setThemeValue(true);
      isDarkTheme = true;
    }

    notifyListeners();
  }

  ThemeData getBool() {
    print(_selectedTheme);
    return _selectedTheme;
  }

  ThemeData getTheme() => _selectedTheme;
  bool getValue() => isDarkTheme;
}
