
import 'package:flutter/material.dart';
import 'package:peton/SearchPage.dart';
import 'package:peton/SettingPage.dart';
import 'package:peton/enums/MyIcons.dart';
import 'package:peton/enums/MyThemeData.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
          ),
        ],
      ),
      child: AppBar(
        centerTitle: true,
        title: Image(
          image: Theme.of(context).brightness == MyThemeData.lightTheme.brightness
              ? AssetImage('assets/mainTitleBlack.png')
              : AssetImage('assets/mainTitleWhite.png'),
          height: 25,
        ),
        leading: GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            )
          },
          child: Container(
            child: Icon(
              MyIcons.settingIcon.icon,
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              )
            },
            child: Container(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(
                MyIcons.searchIcon.icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}