
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/KeywordsDetailsPage.dart';
import 'package:peton/KeywordsSearchPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/enums/CategoryId.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosResponse.dart';

Widget KeywordsGridView(double width, BuildContext context) {

  double itemWidth = width / 2;
  double itemHeight = 40;
  double gridBorderRadiusSize = 12.0;

  List<String> gridData = ['고양이 영상', '강아지 영상', '힐링 영상', '키워드 탐색', '랜덤 영상 재생', '랜덤 채널 찾기'];
  List<IconData> iconDataList = [FontAwesomeIcons.cat, FontAwesomeIcons.dog, FontAwesomeIcons.heart, FontAwesomeIcons.hashtag, FontAwesomeIcons.play, FontAwesomeIcons.search];

  String category = CategoryId.id;

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
      Map<String, String> paramMap = {
        'categoryId' : category,
        'random' : 'true',
        'size' : '1'
      };
      Future<List<VideosResponse>> getData = server.getVideoByParam(paramMap);
      getData.then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: value[0].videoId)),
        );
      });
    } else if (equals(value, gridData[5])) {
      Map<String, String> paramMap = {
        'categoryId' : category,
        'random' : 'true',
        'size' : '1',
        'page' : '0'
      };
      Future<List<Channels>> getData = server.getChannelsByParam(paramMap);
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
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(gridBorderRadiusSize),
          gradient: LinearGradient(
            colors: [
              Colors.brown.withAlpha(200),
              Colors.brown.shade900
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: RaisedButton(
          onPressed: () {
            _pushPage(value);
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: new TextStyle(fontSize: 18.0, color: Colors.white,),
                ),
              ),
              Icon(
                iconDataList[gridData.indexOf(value)],
                color: Colors.white,
              )
              // FaIcon(
              //   FontAwesomeIcons.dog,
              //   color: Colors.white,
              // ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(gridBorderRadiusSize),
          ),
          color: Colors.brown.withAlpha(200),
        ),
      );
    }).toList(),
  );

}
