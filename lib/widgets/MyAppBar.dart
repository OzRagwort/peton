
import 'package:flutter/material.dart';
import 'package:peton/enums/MyIcons.dart';

Widget myAppbar() {
  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Text(
      'title',
      style: TextStyle(
        color: Colors.black,
      ),
    ),
    leading: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Icon(
        MyIcons.settingIcon.icon,
        color: Colors.black,
      ),
    ),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          MyIcons.searchIcon.icon,
          color: Colors.black,
        ),
      ),
    ],
  );
}
