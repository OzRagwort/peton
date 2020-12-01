import 'package:flutter/material.dart';

import 'home_page.dart';
import 'favorite_page.dart';
import 'library_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState(title: 'PetON');

}

class _MainPageState extends State<MainPage>{
  _MainPageState({Key key, this.title});
  final String title;

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
      ),
      body: _buildPage(_selectedTabIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Favorite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            title: Text('Library'),
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
    );
  }
  // 1-2. 탭 화면 (List, Grid Widget 반환)
  Widget _buildPage(index){
    if(index == 0)
      return HomePage();
    else if(index == 1)
      return FavoritePage();
    else
      return LibraryPage();
  }
}
