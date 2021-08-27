
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/KeywordsLatelyPage.dart';
import 'package:peton/KeywordsPopularChannelsPage.dart';
import 'package:peton/KeywordsRecommendPage.dart';
import 'package:peton/KeywordsSmallChannelsPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/enums/CategoryId.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:peton/widgets/KeywordsLatelyHit.dart';
import 'package:peton/widgets/KeywordsGridView.dart';
import 'package:peton/widgets/KeywordsPopularChannels.dart';
import 'package:peton/widgets/KeywordsRecommend.dart';
import 'package:peton/widgets/KeywordsSmallChannels.dart';
import 'package:peton/widgets/Line.dart';
import 'package:peton/widgets/MyAnimatedAppBar.dart';
import 'package:peton/widgets/MyAppBar.dart';

class KeywordsPage extends StatefulWidget {
  @override
  _KeywordsPageState createState() => _KeywordsPageState();
}

class _KeywordsPageState extends State<KeywordsPage> {

  ScrollController _scrollController;

  Future<List<VideosResponse>> keywordsLatelyResponse;
  Future<List<VideosResponse>> keywordsRecommendResponse;
  Future<List<Channels>> popularChannelsResponse;
  Future<List<Channels>> smallChannelsResponse;
  List<VideosResponse> latelyList;
  List<VideosResponse> recommendList;
  List<Channels> popularChannelsList;
  List<Channels> smallChannelsList;

  String category = CategoryId.id;

  void _late() {
    Map<String, String> paramMap = {
      'categoryId' : category,
      'sort' : 'videoPublishedDate,desc',
      'size' : '15',
      'page' : '0'
    };

    keywordsLatelyResponse = server.getVideoByParam(paramMap);
    keywordsLatelyResponse.then((value) {setState(() {
      latelyList = value;
    });});
  }

  void _recommend() {
    Map<String, String> paramMap = {
      'categoryId' : category,
      'score' : '50',
      'random' : 'true',
      'size' : '15',
      'page' : '0'
    };

    keywordsRecommendResponse = server.getVideoByParam(paramMap);
    keywordsRecommendResponse.then((value) {setState(() {
      recommendList = value;
    });});
  }

  void _popularChannels() {
    Map<String, String> paramMap = {
      'categoryId' : category,
      'subscriberover' : '100000',
      'random' : 'true',
      'size' : '15'
    };
    popularChannelsResponse = server.getChannelsByParam(paramMap);
    popularChannelsResponse.then((value) {setState(() {
      popularChannelsList = value;
    });});
  }

  void _smallChannels() {
    Map<String, String> paramMap = {
      'categoryId' : category,
      'subscriberunder' : '50000',
      'random' : 'true',
      'size' : '15'
    };
    smallChannelsResponse = server.getChannelsByParam(paramMap);
    smallChannelsResponse.then((value) {setState(() {
      smallChannelsList = value;
    });});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _late();
    _recommend();
    _popularChannels();
    _smallChannels();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    if (latelyList == null || recommendList == null || popularChannelsList == null || smallChannelsList == null) {
      return Center(child: CupertinoActivityIndicator(),);
    } else {
      return Scaffold(
        body: MyAnimatedAppBar(
          scrollController: _scrollController,
          child: MyAppBar(),
          body: Expanded(
            child: CheckNetwork(
              body: ListView(
                children: [
                  /// 최근 인기 영상
                  Container(
                    height: 45,
                    padding: EdgeInsets.only(left: 30, right: 20),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => KeywordsLatelyPage(popularVideosList: latelyList,)),
                              )
                            },
                            child: Text(
                              "최근 인기 영상",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  KeywordsLatelyHit(latelyList: latelyList,),
                  divline,

                  /// 그리드뷰
                  KeywordsGridView(width, context),
                  divline,

                  /// 추천 영상
                  Container(
                    height: 45,
                    padding: EdgeInsets.only(left: 30, right: 20),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => KeywordsRecommendPage()),
                              )
                            },
                            child: Text(
                              "추천 영상",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  KeywordsRecommend(recommendList: recommendList,),
                  divline,

                  /// 인기 채널
                  Container(
                    height: 45,
                    padding: EdgeInsets.only(left: 30, right: 20),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => KeywordsPopularChannelsPage()),
                              )
                            },
                            child: Text(
                              "인기 채널",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  KeywordsPopularChannels(channelsList: popularChannelsList,),
                  divline,

                  /// 소규모 채널
                  Container(
                    height: 45,
                    padding: EdgeInsets.only(left: 30, right: 20),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => KeywordsSmallChannelsPage()),
                              )
                            },
                            child: Text(
                              "소규모 채널",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  KeywordsSmallChannels(channelsList: smallChannelsList,),
                ],
              ),
            ),
          ),
        ),
      );
    }


  }
}

