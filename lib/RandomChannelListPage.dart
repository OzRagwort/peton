
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/model/Channels.dart';
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

  Future<Map<Channels, List<VideosResponse>>> response;
  Map map = new Map<Channels, List<VideosResponse>>();
  List<Channels> list = new List<Channels>();

  int category = 1;
  String sort = 'popular';
  int channelCount = 10;
  int videoCount = 3;
  int maxResults = 300;

  void _onRefresh() async {

    map = new Map<Channels, List<VideosResponse>>();
    list = new List<Channels>();
    response = server.getVideosByChannels(category, 1, channelCount, sort, 1, videoCount);

    response.then((value) => setState(() {
      map.addAll(value);
      list = map.keys.toList();
    }));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {

    response = server.getVideosByChannels(category, 1, channelCount, sort, 1, videoCount);
    response.then((value) => setState(() {
      map.addAll(value);
      list = map.keys.toList();
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

    Channels channels = list[listNum];
    List<VideosResponse> videosResponse = map[list[listNum]];

    return Column(
      children: [
        channelCardSmall(channels, width),
        _videosCart(videosResponse[0], width - 40),
        _videosCart(videosResponse[1], width - 40),
        _videosCart(videosResponse[2], width - 40),
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
      enablePullUp: map.length < maxResults ? true : false,
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
        itemCount: map.length + channelCount,
        // ignore: missing_return
        itemBuilder: (context, index) {
          if (index == 0 && map.length == 0) {
            return FutureBuilder<Map<Channels, List<VideosResponse>>>(
              future: response,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  map.addAll(snapshot.data);
                  list = map.keys.toList();
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
          if (map.length > index) {
            return _channelsCart(index, MediaQuery.of(context).size.width);
          }
        }
      ),
    );
  }
}

