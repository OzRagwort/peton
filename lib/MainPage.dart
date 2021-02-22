
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/KeywordsPage.dart';
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
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{
  String title;

  /// bottom navi
  int _selectedTabIndex;

  final FirebaseMessaging _fcm = new FirebaseMessaging();

  /// notification
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

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

  /// 켜진 상태로 FCM이 올 경우 flutter_local_notifications를 이용하여 알림
  Future<void> _foregroundClickNotification(Map<String, dynamic> message) async {
    _showNotification(message);
  }

  /// 꺼진 상태로 온 FCM 알림을 클릭 할 때 할 동작
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

  /// flutter_local_notifications config
  void _notificationConfigure() {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/notification_icon');

    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _fcm.getToken().then((value) => print('fcm token : ' + value));

    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  /// flutter_local_notifications 알림 클릭 시 동작
  Future onSelectNotification(String payload) async {
    Map<String, dynamic> message = json.decode(payload);

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

  /// 알림 생성하는 코드
  Future<void> _showNotification(Map<String, dynamic> message) async {
    final String largeIconPath = await _downloadAndSaveFile(
        message["data"]["channel_thumbnail"], 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        message["data"]["video_thumbnail"], 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      contentTitle: message["data"]["title"],
      htmlFormatContentTitle: true,
      summaryText: message["data"]["channel"],
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      message["data"]["notification_channel"], //channel id
      message["data"]["notification_channel"], // channel name
      message["data"]["notification_channel"], // channel description
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      priority: Priority.high,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      message["notification"]["title"],
      message["notification"]["body"],
      platformChannelSpecifics,
      payload: json.encode(message),
    );

  }

  /// 이미지 로드
  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(url);
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }


  @override
  void initState() {
    super.initState();

    // 딥링크 init
    _initDynamicLinks();

    // FCM configure
    _fcmConfigure();

    // notification configure
    _notificationConfigure();

    // 변수 설정
    title = widget.title;
    _selectedTabIndex = widget.index;
  }

  @override
  void dispose() {
    super.dispose();
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
              icon: _selectedTabIndex == 2 ? MyIcons.keywordPageIconFill : MyIcons.keywordPageIcon,
              title: Text('Keyword', style: TextStyle(fontSize: 12),),
            ),
            BottomNavigationBarItem(
              icon: _selectedTabIndex == 3 ? MyIcons.libraryPageIconFill : MyIcons.libraryPageIcon,
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
    } else if(index == 2) {
      return KeywordsPage();
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
