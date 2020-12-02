import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart';

import 'widgets/line.dart';
import 'widgets/cards.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // List<String> myList = <String>['Item1','Item2','Item3','Item4','Item5','Item6','Item7','Item8','Item9', 'Item10'];
  // List<String> addList = <String>['Add1','Add2','Add3','Add4','Add5','Add6','Add7','Add8','Add9','Add10'];
  List<String> myList = <String>['Item1','Item2','Item3','Item4','Item5'];
  List<String> addList = <String>['Add1','Add2','Add3','Add4','Add5','Add6','Add7','Add8','Add9','Add10'];

  Widget _buildSuggestions() {
    // return ListView.builder(
    //   padding: const EdgeInsets.all(16.0),
    //   itemCount: myList?.length+1,
    //   itemBuilder: (context, index) {
    //     log(index.toString());
    //     if(myList.length == index) {
    //       return RaisedButton(
    //         onPressed: () {
    //           myList.addAll(addList);
    //           setState(() {});
    //         }
    //       );
    //       // setState(() => myList.addAll(addList));
    //       // setState(() {myList.addAll(addList);});
    //     }
    //     return videoCard();
    //   }
    // );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    // 썸네일, 제목, 채널, 시간, 채널썸네일, 보관함여부

    return Scaffold(
      // body: _buildSuggestions(),
      body: ListView.builder(
          // padding: const EdgeInsets.all(16.0),
          itemCount: myList?.length+1,
          itemBuilder: (context, index) {
            log(index.toString());
            if(myList.length == index) {
              return RaisedButton(
                  onPressed: () {
                    FutureBuilder(
                      future: server.getReq('RGsIiuf-6Zg'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        myList.add(snapshot.data.videoName);
                        setState(() {});
                        return null;
                      },
                    );
                    // myList.add('addList');
                    // setState(() {});
                  }
              );
            }
            // return videoCard(width);
            return Text(myList[index]);
          }
      ),
    );
  }

}
