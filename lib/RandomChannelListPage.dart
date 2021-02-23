
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_choices/search_choices.dart';

class RandomChannelListPage extends StatefulWidget {
  RandomChannelListPage({
    Key key,
    this.scrollController,
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
  Map<Channels, List<VideosResponse>> map;
  List<Channels> list = new List<Channels>();

  List<Channels> allChannelsList = new List<Channels>();
  List<DropdownMenuItem> channelItems = List<DropdownMenuItem>();

  int category = 1;
  String sort = 'popular';
  int channelCount = 10;
  int videoCount = 3;

  void _onRefresh() {

    map = new Map<Channels, List<VideosResponse>>();
    list = new List<Channels>();
    response = server.getVideosByChannels(category, 1, channelCount, sort, 1, videoCount);

    response.then((value) => setState(() {
      map = value;
      list = map.keys.toList();
    }));

    _refreshController.refreshCompleted();
  }

  void _onLoading() {

    response = server.getVideosByChannels(category, 1, channelCount, sort, 1, videoCount);
    response.then((value) => setState(() {
      map.addAll(value);
      list = map.keys.toList();
    }));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  Widget _videosCard(VideosResponse videosResponse, double width) {
    if (videosResponse != null) {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: videosResponse.videoId)),
          )
        },
        child: videoCardSmall(videosResponse, width),
      );
    } else {
      return null;
    }
  }

  /// 한 채널의 카드
  Widget _channelsCard(int listNum, double width) {

    Channels channels = list[listNum];
    List<VideosResponse> videosResponse = map[list[listNum]];

    /// 3개인것 검증은 server.dart에서
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChannelInfoPage(channel: channels,)),
            );
          },
          child: channelCardSmall(channels, width),
        ),
        _videosCard(videosResponse[0], width - 40),
        _videosCard(videosResponse[1], width - 40),
        _videosCard(videosResponse[2], width - 40),
      ],
    );
  }

  void _getVideos() {
    response = server.getVideosByChannels(category, 1, channelCount, sort, 1, videoCount);
    response.then((value) {setState(() {
      map = value;
      list = map.keys.toList();
    });});
  }

  void _getChannelsAll() async {
    int subscribers = 0;
    int category = 1;
    String sort = 'popular';
    bool rand = false;
    int page = 1;
    int count = 200;
    int responseListLength = 0;

    do {
      List<Channels> buffer = await server.getChannelsBySubscribers(subscribers, true, category, sort, rand, page, count);
      allChannelsList.addAll(buffer);
      responseListLength = buffer.length;
      page++;
    } while (responseListLength != 0);

    setState(() {
      for(Channels channel in allChannelsList) {
        channelItems.add(new DropdownMenuItem(
          value: channel,
          child: channelCardSmallNonIcon(channel, MediaQuery.of(context).size.width),
        ));
      }
    });

  }

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? new ScrollController();
    _getVideos();
    _getChannelsAll();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedValueSingleDialog;

    if (map == null) {
      return Center(child: CupertinoActivityIndicator(),);
    } else {
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
            itemCount: map.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  height: 64,
                  child: RaisedButton(
                    onPressed: () {

                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(color: Colors.grey, ),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: SearchChoices.single(
                        items: channelItems,
                        value: selectedValueSingleDialog,
                        hint: "채널 찾기",
                        isExpanded: true,
                        displayClearIcon: false,
                        searchFn: (keyword, items) {
                          List<int> shownIndexes = [];
                          int i = 0;
                          channelItems.forEach((item) {
                            if (item.value.channelName
                                .toString()
                                .toLowerCase()
                                .contains(keyword.toLowerCase())) {
                              shownIndexes.add(i);
                            }
                            i++;
                          });
                          return (shownIndexes);
                        },
                        onChanged: (Channels value) {
                          setState(() {
                            selectedValueSingleDialog = value?.channelName;
                            if (value != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChannelInfoPage(channel: value,)),
                              );
                            }
                          });
                        },
                        closeButton: Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Theme.of(context).scaffoldBackgroundColor,
                            elevation: 0,
                            child: Text('Close'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );

              } else {
                return _channelsCard(index - 1, MediaQuery.of(context).size.width);
              }
            }
        ),
      );
    }
  }
}

