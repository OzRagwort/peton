
import 'package:auto_size_text/auto_size_text.dart';
import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:peton/widgets/FavoriteIconBuilder.dart';
import 'package:peton/widgets/Line.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'Server.dart';
import 'VideoplayerPage.dart';
import 'model/VideosResponse.dart';

class ChannelInfoPage extends StatefulWidget {
  ChannelInfoPage({this.channel});

  final Channels channel;

  @override
  _ChannelInfoPageState createState() => _ChannelInfoPageState();
}

class _ChannelInfoPageState extends State<ChannelInfoPage> {

  final dataKey = new GlobalKey();

  Channels channel;
  String sort = 'desc'; // 최신순 desc:최신, asc:오래된순, popular:인기순
  int count = 10;

  List<String> _sortList = ['인기 동영상', '최신 순', '오래된 순'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _sortingMethod;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> videosList = new List<VideosResponse>();

  void _onRefresh() async{

    videosList = new List<VideosResponse>();
    videosResponse = server.getByChannelIdSort(channel.channelId, sort, false, 1, count);

    videosResponse.then((value) => setState(() {videosList = value;}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async{

    int index = (videosList.length ~/ 10) + 1;

    videosResponse = server.getByChannelIdSort(channel.channelId, sort, false, index, count);
    videosResponse.then((value) => videosList.addAll(value));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  void _sortRefresh(String index) async{
    if (index == _sortList[0]) {
      sort = 'popular';
    } else if (index == _sortList[1]) {
      sort = 'desc';
    } else {
      sort = 'asc';
    }

    videosList = new List<VideosResponse>();
    videosResponse = server.getByChannelIdSort(channel.channelId, sort, false, 1, count);
    videosResponse.then((value) {setState(() {
      videosList = value;
    });});
  }

  Widget _videosCardSmall(int listNum, double width) {
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

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for(String sortList in _sortList) {
      items.add(new DropdownMenuItem(
        value: sortList,
        child: Text(sortList),
      ));
    }

    return items;
  }

  Widget _sortDropDownMenu() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(Icons.sort, size: 25,),
          spaceLeft,
          DropdownButton<String>(
            icon: Icon(Icons.keyboard_arrow_down),
            value: _sortingMethod,
            iconSize: 24,
            elevation: 16,
            underline: Container(height: 0),
            items: _dropDownMenuItems,
            onChanged: (String newValue) {
              _sortingMethod = newValue;
              _sortRefresh(newValue);
            },
          ),
        ],
      ),
    );
  }
  
  void _getVideos() {
    videosResponse = server.getByChannelIdSort(channel.channelId, sort, false, 1, count);
    videosResponse.then((value) {setState(() {
      videosList = value;
    });});
  }

  @override
  void initState() {
    super.initState();
    channel = widget.channel;
    _dropDownMenuItems = getDropDownMenuItems();
    _sortingMethod = _dropDownMenuItems[1].value;
    _getVideos();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: CheckNetwork(
          slidingUp: true,
          body: SmartRefresher(
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
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: (MediaQuery.of(context).size.width / 16) * 9,
                  leading: IconButton(
                    icon: Icon(Icons.keyboard_backspace),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: CustomizableSpaceBar(
                    builder: (context, scrollingRate) {
                      String bannerImage = channel.bannerExternalUrl != null ? channel.bannerExternalUrl : channel.channelThumbnail;
                      return Container(
                        child: Stack(
                          children: <Widget>[
                            ExtendedImage.network(
                              bannerImage,
                              width: width,
                              fit: BoxFit.fitWidth,
                              cache: true,
                              filterQuality: FilterQuality.high,
                              loadStateChanged: (ExtendedImageState state) {
                                switch (state.extendedImageLoadState) {
                                  case LoadState.loading:
                                    return SizedBox(
                                      width: width,
                                      child: Center(child: CupertinoActivityIndicator(),),
                                    );
                                    break;
                                  case LoadState.completed:
                                    return ExtendedRawImage(
                                      image: state.extendedImageInfo?.image,
                                      width: width,
                                      fit: BoxFit.fitWidth,
                                    );
                                    break;
                                  case LoadState.failed:
                                    return SizedBox(
                                      width: width,
                                      child: Container(),
                                    );
                                    break;
                                }
                                return null;
                              },
                            ),
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).scaffoldBackgroundColor.withOpacity(1.0 - (0.3 * scrollingRate)),
                                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7 * scrollingRate),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: FractionalOffset(0.5, 0.5 * (1 - scrollingRate)),
                                ),
                              ),
                              // padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0 + 35 * scrollingRate),
                              padding: EdgeInsets.only(bottom: 5.0, left: 15.0 + 35 * scrollingRate, right: 15),
                              child: Align(
                                alignment: FractionalOffset(0.0, 1 - (0.5 * scrollingRate)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
                                        channel.channelName,
                                        minFontSize: 20,
                                        maxLines: scrollingRate > 0.6 ? 1 : null,
                                        overflow: scrollingRate > 0.6 ? TextOverflow.ellipsis : null,
                                        style: TextStyle(
                                          color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0xFFFFFF),
                                          fontSize: 28 - 20 * scrollingRate,
                                        ),
                                      ),
                                    ),
                                    FavoriteIconBuilder(channels: channel,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SliverList(
                  key: dataKey,
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == 0) {
                      return _sortDropDownMenu();
                    } else {
                      return _videosCardSmall(index - 1, MediaQuery.of(context).size.width);
                    }
                  },
                    childCount: videosList.length + 1,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.keyboard_arrow_up),
            onPressed: () => Scrollable.ensureVisible(dataKey.currentContext, duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn),
          ),
        ],
      ),
    );
  }
}
