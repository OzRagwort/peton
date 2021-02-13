
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/KeywordsDetailsPage.dart';
import 'package:peton/KeywordsSearchPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosResponse.dart';

Widget KeywordsGridView(double width, BuildContext context) {

  double itemWidth = width / 2;
  double itemHeight = 40;

  List<String> gridData = ['#고양이', '#강아지', '#힐링영상', '키워드 탐색', '랜덤 영상 재생', '랜덤 채널 찾기'];

  void _pushPage(String value) {
    if (equals(value, gridData[0]) || equals(value, gridData[1]) || equals(value, gridData[2])) {
      String keyword;
      if (equals(value, gridData[0])) {
        keyword = '고양이';
      } else if (equals(value, gridData[1])) {
        keyword = '강아지';
      } else {
        keyword = '힐링';
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => KeywordsDetailsPage(keyword: keyword,)),
      );
    } else if (equals(value, gridData[3])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => KeywordsSearchPage()),
      );
    } else if (equals(value, gridData[4])) {
      Future<List<VideosResponse>> getData = server.getRandByCategoryId('1', 1);
      getData.then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: value[0].videoId)),
        );
      });
    } else if (equals(value, gridData[5])) {
      Future<List<Channels>> getData = server.getRandChannels(1, 1, 1);
      getData.then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChannelInfoPage(channel: value[0])),
        );
      });
    } else {

    }
  }

  return GridView.count(
    crossAxisCount: 2,
    childAspectRatio: (itemWidth / itemHeight),
    controller: new ScrollController(keepScrollOffset: false),
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    mainAxisSpacing: 5.0,
    crossAxisSpacing: 5.0,
    padding: const EdgeInsets.all(10),
    children: gridData.map((String value) {
      return RaisedButton(
        onPressed: () {
          _pushPage(value);
        },
        child: Text(
          value,
          style: new TextStyle(fontSize: 18.0,),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.green,
      );
    }).toList(),
  );

}
