import 'package:flutter/material.dart';

class PBColors {
  static const brand_01 = Color(0xFF00B8A2);
  static const brand_02 = Color(0xFFC0C0C3);

  static const text_01 = Color(0xFFF2F2F2);
  static const text_02 = Color(0xFF154859);
  static const text_03 = Color(0xFFAAAAAA);

  static const ui_01 = Color(0xFFFFFFFF);
  static const ui_02 = Color(0xFF888888);
  static const ui_03 = Color(0xFF3A6471);

  static const footer_01 = Color(0xFF090b0b);
  static const footer_02 = Color(0xFF555555);
}

TextTheme pbTextTheme = TextTheme(
  headline1: TextStyle(
      fontSize: 32.0,
      color: PBColors.text_01,
      fontWeight: FontWeight.bold,
      letterSpacing: 5),
  headline2: TextStyle(
      fontSize: 24.0,
      color: PBColors.text_01,
      fontWeight: FontWeight.bold,
      letterSpacing: 5),
  headline3: TextStyle(
      fontSize: 20.0, color: PBColors.text_02, fontWeight: FontWeight.normal),
  headline4: TextStyle(
      fontSize: 18.0, color: PBColors.text_02, fontWeight: FontWeight.normal),
  headline5: TextStyle(
      fontSize: 16.0, color: PBColors.text_01, fontWeight: FontWeight.normal),
  headline6: TextStyle(
      fontSize: 18.0, color: PBColors.text_03, fontWeight: FontWeight.normal),
  bodyText1: TextStyle(
      fontSize: 16.0,
      color: PBColors.text_01,
      fontWeight: FontWeight.normal,
      height: 1.5),
  bodyText2: TextStyle(
      fontSize: 16.0, color: PBColors.text_02, fontWeight: FontWeight.normal),
  subtitle1: TextStyle(
      fontSize: 14.0, color: PBColors.text_02, fontWeight: FontWeight.normal),
  subtitle2: TextStyle(
      fontSize: 12.0, color: PBColors.text_02, fontWeight: FontWeight.normal),
);

ThemeData pbThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: PBColors.brand_01,
  primaryColorDark: PBColors.brand_02,
  accentColor: PBColors.text_02,
  dividerTheme: DividerThemeData(color: Colors.white),
  iconTheme: IconThemeData(color: Colors.black),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: pbTextTheme,
  buttonColor: PBColors.text_01,
  dividerColor: PBColors.text_03,
  backgroundColor: PBColors.ui_01,
);

ThemeData pbDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  primaryColorDark: PBColors.brand_02,
  dividerTheme: DividerThemeData(color: Colors.grey),
  iconTheme: IconThemeData(color: Colors.white),
  inputDecorationTheme: InputDecorationTheme(fillColor: Color(0xff4e4946)),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: pbTextTheme,
);

ShapeBorder bottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
  ),
);
