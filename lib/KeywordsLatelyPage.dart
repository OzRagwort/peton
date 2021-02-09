
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/enums/MyIcons.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CarouselWithNonIndicatorVideos.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KeywordsLatelyPage extends StatefulWidget {
  KeywordsLatelyPage({this.popularVideosList});

  final List<VideosResponse> popularVideosList;

  @override
  _KeywordsLatelyPageState createState() => _KeywordsLatelyPageState();
}

class _KeywordsLatelyPageState extends State<KeywordsLatelyPage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<List<VideosResponse>> latelyVideosResponse;
  Future<List<VideosResponse>> recommendVideosResponse;
  List<VideosResponse> latelyVideosList = new List<VideosResponse>();
  List<VideosResponse> popularVideosList = new List<VideosResponse>();
  List<VideosResponse> recommendVideosList = new List<VideosResponse>();

  bool showRecommend;
  bool showPopular;

  String sort = 'desc';
  int category = 1;
  int page = 1;
  int count = 10;

  void _onRefresh() {

    latelyVideosList = new List<VideosResponse>();
    String sort = 'desc';
    int category = 1;
    int page = 1;
    int count = 10;
    latelyVideosResponse = server.getVideosBySort(sort, category, page, count);

    latelyVideosResponse.then((value) => setState(() {latelyVideosList.addAll(value);}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() {

    page++;
    latelyVideosResponse = server.getVideosBySort(sort, category, page, count);
    latelyVideosResponse.then((value) => latelyVideosList.addAll(value));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  Widget _videosCart(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: latelyVideosList[listNum].videoId)),
        )
      },
      child: videoCard(latelyVideosList[listNum], width),
    );
  }

  void _getLatelyVideos() {
    latelyVideosResponse = server.getVideosBySort(sort, category, page, count);

    latelyVideosResponse.then((latelyValue) {setState(() {
      latelyVideosList = latelyValue;
    });});
  }

  void _getRecommendVideos() {
    recommendVideosResponse = server.getVideosByPublishedDate(72, 1, 'desc-score', false, Random().nextInt(5) + 1, 15);

    recommendVideosResponse.then((recommendValue) {setState(() {
      recommendVideosList = recommendValue;
    });});
  }

  Widget _carouselVideos() {
    if (showRecommend) {
      return CarouselWithNonIndicatorVideos(videos: recommendVideosList,);
    } else if (showPopular) {
      return CarouselWithNonIndicatorVideos(videos: popularVideosList,);
    } else {
      return Text('');
    }
  }

  Widget _specialTaps(double height) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: AnimatedContainer(
            height: (showRecommend || showPopular) ? 0.0 : 40,
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: RaisedButton(
                      onPressed: () {setState(() {
                        showPopular = false;
                        showRecommend = true;
                      });},
                      child: Text(
                        '오늘의 추천 영상',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: RaisedButton(
                      onPressed: () {setState(() {
                        showRecommend = false;
                        showPopular = true;
                      });},
                      child: Text(
                        '실시간 인기 영상',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: AnimatedContainer(
            height: (showRecommend || showPopular) ? 40.0 : 0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: GestureDetector(
              onTap: () {setState(() {
                showPopular = false;
                showRecommend = false;
              });},
              child: Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0, right: 20, left: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Text(
                          showRecommend ? '오늘의 추천 영상' : showPopular ? '실시간 인기 영상' : '',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    MyIcons.sortUpIcon,
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          height: (showRecommend || showPopular) ? height / 3 : 0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: _carouselVideos(),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _getLatelyVideos();
    _getRecommendVideos();
    popularVideosList = widget.popularVideosList;
    showRecommend = false;
    showPopular = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("실시간 업로드 영상"),
      ),
      body: CheckNetwork(
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: MaterialClassicHeader(),
          footer: CustomFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("더보기");
              }
              else if(mode==LoadStatus.loading){
                body =  CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("로딩 재시도");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("더보기");
              }
              else{
                body = Text("");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
              itemCount: latelyVideosList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _specialTaps(height);
                } else {
                  return _videosCart(index-1, width);
                }
              }
          ),
        ),
      ),
    );
  }
}

