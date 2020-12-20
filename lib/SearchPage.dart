
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.lightBlueAccent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
              ),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Icon(Icons.search),
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: Text(textController.text),);
                }
            ),
          ),
        ],
      ),
    );
  }
}
