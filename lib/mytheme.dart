import 'package:flutter/material.dart';

class MyTheme {
  static Color primaryLight = Color(0xff5D9CEC);
  static Color backgroundLight = Color(0xffDFECDB);
  static Color greenColor = Color(0xff61E757);
  static Color redColor = Color(0xffEC4B4B);
  static Color whiteColor = Color(0xffffffff);
  static Color blackColor = Color(0xff303030);
  static Color greyColor = Color(0xff403d3d);
  static Color backgroundDark = Color(0xff060E1E);
  static Color blackDark = Color(0xff141922);

  static ThemeData LightMode = ThemeData(
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryLight,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: primaryLight,
          unselectedItemColor: greyColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryLight,
          shape: StadiumBorder(side: BorderSide(color: whiteColor, width: 4))),
      textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: whiteColor),
          titleMedium: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: blackColor),
          titleSmall: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: blackColor)));

  static ThemeData DarkMode = ThemeData(
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryLight,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: blackDark,
          elevation: 0,
          selectedItemColor: primaryLight,
          unselectedItemColor: whiteColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryLight,
          shape: StadiumBorder(side: BorderSide(color: whiteColor, width: 4))),
      textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: whiteColor),
          titleMedium: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: whiteColor),
          titleSmall: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: whiteColor)));
}
