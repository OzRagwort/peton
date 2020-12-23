
import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  List<String> _themetList = ['Light', 'Dark', 'System'];
  List<DropdownMenuItem<String>> _themeDropDownMenuItems;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for(String sortList in _themetList) {
      items.add(new DropdownMenuItem(
        value: sortList,
        child: Text(sortList),
      ));
    }
    return items;
  }

  void _themeRefresh(String index) async{
    if (index == _themetList[0]) {
      AdaptiveTheme.of(context).setLight();
    } else if (index == _themetList[1]) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setSystem();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _themeDropDownMenuItems = getDropDownMenuItems();
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
          ],
        ),
      ),
    );
  }
}
