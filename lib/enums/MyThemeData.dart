
import 'package:flutter/material.dart';

class MyThemeData {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    accentColor: Colors.orangeAccent,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 18)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.black),
        showSelectedLabels: true,
        unselectedItemColor: Colors.black87,
        unselectedLabelStyle: TextStyle(color: Colors.black87),
        showUnselectedLabels: true
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.white,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.black12,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(title: TextStyle(color: Colors.white, fontSize: 18)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.white),
        showSelectedLabels: true,
        unselectedItemColor: Colors.white70,
        unselectedLabelStyle: TextStyle(color: Colors.white70),
        showUnselectedLabels: true
    ),
  );

}