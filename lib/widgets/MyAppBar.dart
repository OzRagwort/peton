
import 'package:flutter/material.dart';

Widget myAppbar() {
  return AppBar(
    backgroundColor: Colors.white,
    title: Center(
      child: Text(
        'title',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    actions: <Widget>[
//add buttons here
    ],
  );
}
