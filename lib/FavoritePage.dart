import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/VideoplayerPage.dart';

import 'Server.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key : key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  Widget build(BuildContext context) {

    String json = '{idx:1234,categoriesIdx:1,channels:{createdDate:2020-11-20T16:25:07,modifiedDate:2020-11-20T16:25:07,idx:3,channelId:UCmyFB-ySHaEG2W31RYLwROA,channelName:모카라떼베리MochaLatteBerry,channelThumbnail:https://yt3.ggpht.com/ytc/AAUvwnhRp8_VpQLjvnurqsZjZXdzWqVS-LI9X8icnl8ceQ=s240-c-k-c0x00ffffff-no-rj,uploadsList:UUmyFB-ySHaEG2W31RYLwROA,subscribers:112000},videoId:V9ggmDwX7lM,videoName:아기고양이가 입양 첫날 집에와서 하는 귀여운 행동 모음,videoThumbnail:https://i.ytimg.com/vi/V9ggmDwX7lM/mqdefault.jpg,videoDescription:아기고양이가 입양 첫날 집에와서 하는 귀여운 행동 모음\n\n-출처-\nMusic provided by 브금대통령\nTrack : 사뿐사뿐 나들이 - https://youtu.be/bFANkXSQwJg\nTrack : 맛있다 달고나커피 - https://youtu.be/lhgAmp0S-TU\nTrack : Spring Bossa - https://youtu.be/1gmzasoTIL4,videoPublishedDate:2020-08-01T14:50:13Z,videoDuration:null,videoPublicStatsViewable:false,viewCount:0,likeCount:0,dislikeCount:0,commentCount:0,tags:[]}';

    // print(jsonDecode(json));

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
          child:
          FutureBuilder<VideosResponse>(
            future: server.getReq("UcxRP-T8_Ng"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VideowatchPage(videoId: snapshot.data.videoId)),
                    )
                  },
                  child: Card(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 7.0),
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: <Widget>[
                          Image.network(
                            snapshot.data.videoThumbnail,
                            width: width-32,
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
    );

  }

}

