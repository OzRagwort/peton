
import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<String> _themetList = ['Light', 'Dark', 'System'];
  List<DropdownMenuItem<String>> _themeDropDownMenuItems;

  List<String> _startPageList = ['Home', 'Favorite', 'Library'];
  List<DropdownMenuItem<String>> _startPageDropDownMenuItems;

  List<DropdownMenuItem<String>> getDropDownMenuItems(List<String> lists) {
    List<DropdownMenuItem<String>> items = new List();
    for(String list in lists) {
      items.add(new DropdownMenuItem(
        value: list,
        child: Text(list),
      ));
    }
    return items;
  }

  void _themeRefresh(String index) async {
    if (index == _themetList[0]) {
      AdaptiveTheme.of(context).setLight();
    } else if (index == _themetList[1]) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setSystem();
    }
    setState(() {});
  }

  Future<String> _startPageSetting() async {
    final SharedPreferences prefs = await _prefs;
    int startPage = (prefs.getInt('start_page') ?? 0);
    log('startpage : '+startPage.toString());
    if (startPage == 0)
      return 'Home';
    else if (startPage == 1)
      return 'Favorite';
    else
      return 'Library';
  }

  void _startPageRefresh(String index) async {
    final SharedPreferences prefs = await _prefs;
    if (index == _startPageList[0]) {
      prefs.setInt('start_page', 0);
    } else if (index == _startPageList[1]) {
      prefs.setInt('start_page', 1);
    } else {
      prefs.setInt('start_page', 2);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _themeDropDownMenuItems = getDropDownMenuItems(_themetList);
    _startPageDropDownMenuItems = getDropDownMenuItems(_startPageList);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 테마
            Row(
              children: [
                Expanded(
                  child: Text(
                    'theme',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                FutureBuilder<AdaptiveThemeMode>(
                    future: AdaptiveTheme.getThemeMode(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        log(snapshot.data.name);
                        return DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down),
                          value: snapshot.data.name,
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(height: 0),
                          items: _themeDropDownMenuItems,
                          onChanged: (String newValue) {
                            _themeRefresh(newValue);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Text('');
                    }
                ),
              ],
            ),

            /// 시작 페이지
            Row(
              children: [
                Expanded(
                  child: Text(
                    'start page',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                FutureBuilder<String>(
                    future: _startPageSetting(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        log(snapshot.data);
                        return DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down),
                          value: snapshot.data,
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(height: 0),
                          items: _startPageDropDownMenuItems,
                          onChanged: (String newValue) {
                            log('//'+newValue);
                            _startPageRefresh(newValue);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Text('');
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
