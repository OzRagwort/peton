import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/enums/MyIcons.dart';
import 'package:peton/model/Channels.dart';

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

  final FirebaseMessaging _fcm = new FirebaseMessaging();

  NotificationAppLaunchDetails notificationAppLaunchDetails;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            _handleDynamicLink(deepLink);
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      _handleDynamicLink(deepLink);
    }
  }

  void _handleDynamicLink(Uri deepLink) {
    switch (deepLink.path) {
      case "/video":
        var videoId = deepLink.queryParameters['id'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: videoId)),
        );
    }
  }

  void _fcmConfigure() {
    _fcm.configure(
      // 앱 실행중
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _foregroundClickNotification(message);
      },
      onBackgroundMessage: backgroundMessageHandler,
      // 앱 완전 종료
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _backgroundClickNotification(message);
      },
      // 백그라운드 실행중
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _backgroundClickNotification(message);
      },
    );
  }

  Future<void> _foregroundClickNotification(Map<String, dynamic> message) async {}

  Future<void> _backgroundClickNotification(Map<String, dynamic> message) async {
    if (message.containsKey("data")) {
      if (message["data"]["videoId"] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: message["data"]["videoId"])),
        );
      } else if (message["data"]["channelId"] != null) {
        Channels channels = await server.getChannel(message["data"]["channelId"]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChannelInfoPage(channel: channels)),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initDynamicLinks();

    _fcmConfigure();

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

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey("data")) {
    // Handle data message
    final dynamic data = message["data"];
  }

  if (message.containsKey("notification")) {
    // Handle notification message
    final dynamic notification = message["notification"];
  }

  // Or do other work.
}
