
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/enums/CategoryId.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KeywordsRecommendPage extends StatefulWidget {
  @override
  _KeywordsRecommendPageState createState() => _KeywordsRecommendPageState();
}

class _KeywordsRecommendPageState extends State<KeywordsRecommendPage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<String> classNames = ['인기 채널', '10만 이상', '소규모', '고양이', '강아지'];
  int index = 0;
  String category = CategoryId.id;
  String channelSort = 'asc';
  int page = 1;
  int count = 10;

  int bestChannel = 300000;
  int popularChannel = 100000;
  int smallChannel = 30000;

  Map<int, Future<List<VideosResponse>>> mapFuture = new Map<int, Future<List<VideosResponse>>>();
  Map<int, List<VideosResponse>> mapList = new Map<int, List<VideosResponse>>();

  void _onRefresh() {
    mapList[index] = new List<VideosResponse>();
    int page = 1;

    if (index == 0) {
      mapFuture[index] = server.getVideosBySubscribers(bestChannel, true, category, channelSort, true, page, count);
    } else if(index == 1) {
      mapFuture[index] = server.getVideosBySubscribers(popularChannel, true, category, channelSort, true, page, count);
    } else if(index == 2) {
      mapFuture[index] = server.getVideosBySubscribers(smallChannel, false, category, channelSort, true, page, count);
    } else {
      mapFuture[index] = server.getVideosByTags(classNames[index], category, true, page, count);
    }

    mapFuture[index].then((value) => setState(() {
      mapList[index].addAll(value);
    }));

    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    page++;

    if (index == 0) {
      mapFuture[index] = server.getVideosBySubscribers(bestChannel, true, category, channelSort, true, page, count);
    } else if(index == 1) {
      mapFuture[index] = server.getVideosBySubscribers(popularChannel, true, category, channelSort, true, page, count);
    } else if(index == 2) {
      mapFuture[index] = server.getVideosBySubscribers(smallChannel, false, category, channelSort, true, page, count);
    } else {
      mapFuture[index] = server.getVideosByTags(classNames[index], category, true, page, count);
    }

    mapFuture[index].then((value) => setState(() {
      mapList[index].addAll(value);
    }));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  Widget _buttons() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, idx) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 3),
            child: RaisedButton(
              color: index == idx ? Colors.black87 : Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(color: Colors.black38),
              ),
              onPressed: () {setState(() {
                index = idx;
                _onRefresh();
              });},
              child: Text(
                classNames[idx],
                style: TextStyle(
                  color: index == idx ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _videosCard(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: mapList[index][listNum].videoId)),
        )
      },
      child: videoCard(mapList[index][listNum], width),
    );
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("추천 영상"),
        centerTitle: false,
      ),
      body: CheckNetwork(
        body: Column(
          children: <Widget>[
            _buttons(),
            Expanded(
              child: SmartRefresher(
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
                    itemCount: mapList[index].length,
                    itemBuilder: (context, index) {
                      return _videosCard(index, width);
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}