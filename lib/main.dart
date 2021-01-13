import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:peton/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 테마 설정
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  // 설정값
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;

  runApp(MyApp(savedThemeMode: savedThemeMode, prefs: prefs));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;
  final SharedPreferences prefs;
  const MyApp({Key key, this.savedThemeMode, this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 18)),
        ),
        primaryColor: Colors.black,
        accentColor: Colors.orangeAccent,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        // primarySwatch: Colors.white,
        accentColor: Colors.white,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'PetON',
        theme: theme,
        darkTheme: darkTheme,
        home: MainPage(
          title: 'PetON',
          index: (prefs.getInt('start_page') ?? 0) ,
        ),
      ),
    );
  }
}

