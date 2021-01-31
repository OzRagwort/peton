
import 'package:flutter/material.dart';

class MyThemeData {

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 18)),
    ),
    primaryColor: Colors.black,
    accentColor: Colors.orangeAccent,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // primarySwatch: Colors.white,
    accentColor: Colors.white,
  );

}