import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peton/enums/MyIcons.dart';

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
              icon: _selectedTabIndex == 0 ? MyIcons.homePageIconFill : MyIcons.homePageIcon,
              title: Text('Home', style: TextStyle(fontSize: 12),),
            ),
            BottomNavigationBarItem(
              icon: _selectedTabIndex == 1 ? MyIcons.favoritePageIconFill : MyIcons.favoritePageIcon,
              title: Text('Favorite', style: TextStyle(fontSize: 12),),
            ),
            BottomNavigationBarItem(
              icon: _selectedTabIndex == 2 ? MyIcons.libraryPageIconFill : MyIcons.libraryPageIcon,
              title: Text('Library', style: TextStyle(fontSize: 12),),
            ),
          ],
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
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
