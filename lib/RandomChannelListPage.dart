
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/model/VideosByChannels.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RandomChannelListPage extends StatefulWidget {
  RandomChannelListPage({
    Key key,
    this.scrollController
  }) : super(key: key);

  ScrollController scrollController;

  @override
  _RandomChannelListPageState createState() => _RandomChannelListPageState();
}

class _RandomChannelListPageState extends State<RandomChannelListPage> {

  ScrollController _scrollController;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<List<VideosByChannels>> response;
  List<VideosByChannels> list = new List<VideosByChannels>();

  int category = 1;
  String sort = 'popular';
  int channelCount = 10;
  int videoCount = 3;

  void _onRefresh() async {

    list = new List<VideosByChannels>();
    response = server.getVideosByChannels(category, 1, channelCount, sort, 1, videoCount);

    response.then((value) => setState(() {
      list.addAll(value);
    }));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {

    response = server.getVideosByChannels(category, 1, channelCount, sort, 1, videoCount);
    response.then((value) => setState(() {
      list.addAll(value);
    }));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  Widget _videosCart(VideosResponse videosResponse, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: videosResponse.videoId)),
        )
      },
      child: videoCardSmall(videosResponse, width),
    );
  }

  Widget _channelsCart(int listNum, double width) {

    return Column(
      children: [
        channelCardSmall(list[listNum].channels, width),
        _videosCart(list[listNum].listVideosResponse[0], width - 40),
        _videosCart(list[listNum].listVideosResponse[1], width - 40),
        _videosCart(list[listNum].listVideosResponse[2], width - 40),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? new ScrollController();
    response = server.getVideosByChannels(category, 1, channelCount, sort, 1, videoCount);
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: MaterialClassicHeader(),
      footer: CustomFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        builder: (BuildContext context, LoadStatus mode){
          Widget body ;
          /// 로드 완료 후
          if(mode==LoadStatus.idle){
            body =  Text("pull up load");
          }
          /// ?
          else if(mode==LoadStatus.loading){
            body =  CupertinoActivityIndicator();
          }
          /// ?
          else if(mode == LoadStatus.failed){
            body = Text("Load Failed!Click retry!");
          }
          /// 로드하려고 풀업했을 때 나타는 것
          else if(mode == LoadStatus.canLoading){
            body = Text("Load more");
          }
          /// ?
          else{
            body = Text("No more Data");
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
        controller: _scrollController,
        itemCount: list.length + channelCount,
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (index == 0 && list.length == 0) {
            return FutureBuilder<List<VideosByChannels>>(
              future: response,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  list.addAll(snapshot.data);
                  return _channelsCart(index, MediaQuery.of(context).size.width);
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  _onRefresh();
                }
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              },
            );
          }
          if (list.length > index) {
            return _channelsCart(index, MediaQuery.of(context).size.width);
          }
        }
      ),
    );
  }
}

