import 'package:flutter/material.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/model/customize.dart';
import 'package:keysight_pma/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static const String ACCESS_TOKEN_PREF = "ACCESS_TOEKN_PREF";
  static const String REFRESH_TOKEN_PREF = "REFRESH_TOKEN_PREF";
  static const String ID_TOKEN_PREF = "ID_TOKEN_PREF";
  static const String CUSTOM_SERVER_PREF = "CUSTOM_SERVER_PREF";

  static const String LANGUAGE_CODE_PREF = "LANGUAGE_CODE_PREF";
  static const String USER_INFO = "USER_INFO";
  static const String APP_THEME_PREF = "APP_THEME_PREF";
  static UserDTO? me;
  static SortFilterCacheDTO? sortFilterCacheDTO = SortFilterCacheDTO();
  static bool isFromAlert = false;

  static Map<String, dynamic>? payload;

  static Future<void> setInteger(String key, int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  static Future<int> getIntegerValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? 0;
  }

  static Future<void> setDouble(String key, double value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(key, value);
  }

  static Future<double> getDoubleValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble(key) ?? 0.0;
  }

  static Future<void> setBoolean(String key, bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  static Future<bool> getbooleanValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static Future<String> getStringValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String data = pref.getString(key) ?? "";
    return data;
  }

  static void setAuthToken(
      String accessToken, String refreshToken, String idToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(ACCESS_TOKEN_PREF, accessToken);
    pref.setString(REFRESH_TOKEN_PREF, refreshToken);
    pref.setString(ID_TOKEN_PREF, idToken);
  }

  static void removeAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(ACCESS_TOKEN_PREF);
    prefs.remove(REFRESH_TOKEN_PREF);
    prefs.remove(ID_TOKEN_PREF);
  }

  static void removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(ACCESS_TOKEN_PREF);
    prefs.remove(REFRESH_TOKEN_PREF);
    me = null;
    sortFilterCacheDTO = null;
  }

  static Future<bool> containValue(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool checkValue = _prefs.containsKey(key);
    return checkValue;
  }

  static Future<bool> setStringList(String key, List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, list);
  }

  static Future<List<String>?> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static Future<Locale> setLocate(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(LANGUAGE_CODE_PREF, languageCode);
    return Utils.mylocale(languageCode);
  }

  static Future<String> getLocate() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(LANGUAGE_CODE_PREF) ?? 'en';
    return languageCode;
  }

  static void setThemeValue(bool themeValue) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('darkTheme', themeValue);
  }

  static Future<bool> getThemeValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool data = pref.getBool("darkTheme") ?? true;
    return data;
  }
}
