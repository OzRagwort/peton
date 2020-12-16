import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'HomePage.dart';
import 'FavoritePage.dart';
import 'LibraryPage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title, this.index}) : super(key: key);

  final String title;
  final int index;

  @override
  _MainPageState createState() => _MainPageState(title: 'PetON', index: index);

}

class _MainPageState extends State<MainPage>{
  _MainPageState({this.title, this.index});
  final String title;
  final int index;

  /// bottom navi
  int _selectedTabIndex;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = index;
  }

  @override
  void dispose() {
    super.dispose();
    log('Main Dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          title: Text(''),
          backgroundColor: Colors.white,
        ),
      ),
      body: _buildPage(_selectedTabIndex),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: BottomNavigationBar(
          iconSize: 21,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('Home', style: TextStyle(fontSize: 12),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: Text('Favorite', style: TextStyle(fontSize: 12),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_add_check),
              title: Text('Library', style: TextStyle(fontSize: 10),),
            ),
          ],
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
              print("$_selectedTabIndex Tab Clicked");
            });
          },
        ),
      ),
    );
  }

  Widget _buildPage(index){
    if(index == 0) {
      return HomePage();
    } else if(index == 1) {
      return FavoritePage();
    } else {
      return LibraryPage();
    }
  }
}
