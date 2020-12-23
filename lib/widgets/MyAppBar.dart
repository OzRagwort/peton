
import 'package:flutter/material.dart';
import 'package:peton/SearchPage.dart';
import 'package:peton/SettingPage.dart';
import 'package:peton/enums/MyIcons.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'title',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      leading: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingPage()),
          )
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(
            MyIcons.settingIcon.icon,
            color: Colors.black,
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
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              MyIcons.searchIcon.icon,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}