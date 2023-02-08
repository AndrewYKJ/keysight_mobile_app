import 'package:flutter/material.dart';

class AppFonts {
  static TextStyle robotoThin(
    double size, {
    Color? color,
    TextDecoration? decoration,
  }) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w100,
        color: color,
        decoration: decoration);
  }

  static TextStyle robotoLight(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w300,
        color: color,
        decoration: decoration);
  }

  static TextStyle robotoRegular(double size,
      {Color? color, TextDecoration? decoration, double? height}) {
    return TextStyle(
        height: height,
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        decoration: decoration);
  }

  static TextStyle robotoMedium(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color,
        decoration: decoration);
  }

  static TextStyle robotoBold(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        decoration: decoration);
  }

  static TextStyle robotoBlack(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        decoration: decoration);
  }

  static TextStyle sfproBold(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'SfPro',
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        decoration: decoration);
  }

  static TextStyle sfproMedium(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'SfPro',
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color,
        decoration: decoration);
  }

  static TextStyle sfproRegular(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'SfPro',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        decoration: decoration);
  }

  static TextStyle sfproLight(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'SfPro',
        fontStyle: FontStyle.italic,
        fontSize: size,
        fontWeight: FontWeight.w100,
        color: color,
        decoration: decoration);
  }
}
