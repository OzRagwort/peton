
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/enums/CategoryId.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KeywordsDetailsPage extends StatefulWidget {
  KeywordsDetailsPage({this.keyword});

  final String keyword;

  @override
  _KeywordsDetailsPageState createState() => _KeywordsDetailsPageState();
}

class _KeywordsDetailsPageState extends State<KeywordsDetailsPage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> videosList = new List<VideosResponse>();
  Map<String, Channels> channelsMap = new Map<String, Channels>();
  List<String> channelsKey = new List<String>();

  bool pullUp = true;

  String keyword;
  int size = 20;
  String category = CategoryId.id;

  Map<String, String> _getParamMap() {
    Map<String, String> paramMap = {
      'categoryId' : category,
      'tags' : keyword,
      'random' : 'true',
      'size' : size.toString()
    };

    return paramMap;
  }

  void _onRefresh() {
    videosList = new List<VideosResponse>();
    channelsMap = new Map<String, Channels>();
    channelsKey = new List<String>();

    _getVideos();

    _refreshController.refreshCompleted();
  }

  void _onLoading() {

    Map<String, String> paramMap = _getParamMap();
    videosResponse = server.getVideoByParam(paramMap);
    videosResponse.then((value) {setState(() {
      if (value.length < size) {
        pullUp = false;
      }
      videosList.addAll(value);
    });});

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  Widget _videosCard(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: videosList[listNum].videoId)),
        )
      },
      child: videoCard(videosList[listNum], width),
    );
  }

  Widget _channelListView() {
    double channelsWidth = MediaQuery.of(context).size.width / 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
          child: Text(
            '채널 리스트',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: channelsWidth + 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: channelsMap.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChannelInfoPage(channel: channelsMap[channelsKey[index]])),
                    );
                  },
                  child: Column(
                    children: [
                      ExtendedImage.network(
                        channelsMap[channelsKey[index]].channelThumbnail,
                        width: channelsWidth,
                        fit: BoxFit.fill,
                        cache: true,
                        shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(channelsWidth/2)),
                        // ignore: missing_return
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return SizedBox(width: channelsWidth, height: channelsWidth,);
                              break;
                            case LoadState.completed:
                              return ExtendedRawImage(
                                image: state.extendedImageInfo?.image,
                                width: channelsWidth,
                                fit: BoxFit.fitWidth,
                              );
                              break;
                            case LoadState.failed:
                              return SizedBox(width: channelsWidth, height: channelsWidth,);
                              break;
                          }
                        },
                      ),
                      SizedBox(
                        width: channelsWidth,
                        child: Text(
                          channelsMap[channelsKey[index]].channelName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _getVideos() {
    Map<String, String> paramMap = _getParamMap();
    videosResponse = server.getVideoByParam(paramMap);
    videosResponse.then((value) {setState(() {
      if (value.length < size) {
        pullUp = false;
      }
      videosList = value;
      value.forEach((e) {
        if (!channelsKey.contains(e.channels.channelId)) {
          channelsKey.add(e.channels.channelId);
          channelsMap[e.channels.channelId] = e.channels;
        }
      });
    });});
  }

  @override
  void initState() {
    super.initState();
    keyword = widget.keyword;
    _getVideos();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('$keyword 영상'),
        centerTitle: false,
      ),
      body: CheckNetwork(
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: pullUp ? true : false,
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
              itemCount: videosList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _channelListView();
                } else {
                  return _videosCard(index-1, width);
                }
              }
          ),
        ),
      ),
    );
  }
}

