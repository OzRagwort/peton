
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peton/RandomChannelListPage.dart';
import 'package:peton/database/FavoriteChannelsDb.dart';
import 'package:peton/enums/MyIcons.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:peton/widgets/MyAnimatedAppBar.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/Line.dart';
import 'package:peton/widgets/MyAppBar.dart';
import 'package:peton/widgets/TextForm.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'Server.dart';
import 'model/Channels.dart';

class FavoritePage extends StatefulWidget {

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  bool isScrollingDown = false;

  /// hide appbar
  ScrollController _scrollController;

  /// 구독 채널들 저장 변수
  List<Channels> listChannels;

  /// 정렬 관련, count 관련 변수
  List<String> _sortList = ['인기 동영상', '최신 순', '오래된 순'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _sortingMethod;
  String sort = 'desc'; // 최신순
  int count = 10;

  /// 리프레시
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  /// 채널 클릭 확인 변수
  int _channelClickCheck;

  /// 채널들의 영상이 저장될 곳
  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> listVideos = new List<VideosResponse>();

  String _listToString(List<Channels> list) {
    List<String> listStr = new List<String>();

    for (int i = 0; i < list.length; i++) {
      String name = list[i].channelId;
      listStr.add(name);
    }

    return listStr.join(',');
  }

  void _onRefresh() {

    listVideos = new List<VideosResponse>();
    videosResponse = server.getByChannelIdSort(_listToString(listChannels), sort, 1, count);
    videosResponse.then((value) => setState(() {listVideos.addAll(value);}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() {

    int index = (listVideos.length ~/ 10) + 1;

    videosResponse = server.getByChannelIdSort(_listToString(listChannels), sort, index, count);
    videosResponse.then((value) => listVideos.addAll(value));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  void _sortRefresh(String index) {
    if (index == _sortList[0]) {
      sort = 'popular';
    } else if (index == _sortList[1]) {
      sort = 'desc';
    } else {
      sort = 'asc';
    }

    listVideos = new List<VideosResponse>();
    videosResponse = server.getByChannelIdSort(_listToString(listChannels), sort, 1, count);
    videosResponse.then((value) {setState(() {
        listVideos.addAll(value);
      });});
  }

  void _onClickChannel(int index) {

    _channelClickCheck = index;
    listVideos = new List<VideosResponse>();
    videosResponse = server.getByChannelIdSort(listChannels[index].channelId, sort, 1, count);
    videosResponse.then((value) {setState(() {
      listVideos.addAll(value);
    });});
  }

  void _offClickChannel(int index) async {

    _channelClickCheck = null;
    _onRefresh();
  }

  Widget _videosCart(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: listVideos[listNum].videoId)),
        )
      },
      child: videoCard(listVideos[listNum], width),
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

  Widget _favoriteChannelList() {
    return AnimatedContainer(
      height: isScrollingDown ? 90 : 125,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutExpo,
      child: Container(
        alignment: Alignment.topLeft,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(10),
          itemCount: listChannels.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  if (_channelClickCheck == index) {
                    _offClickChannel(index);
                  } else {
                    _onClickChannel(index);
                  }
                },
                child: Opacity(
                  opacity: (_channelClickCheck == null) || (_channelClickCheck == index) ? 1.0 : 0.6,
                  child: Container(
                    color: _channelClickCheck == index ? Colors.lightBlueAccent.withOpacity(0.3) : Color(0x00000000),
                    child: Column(
                      children: [
                        channelThumbnailCircle(listChannels[index].channelThumbnail, isScrollingDown ? 17.5 : 35),
                        space,
                        ConstrainedBox(
                          constraints: isScrollingDown ? BoxConstraints(maxWidth: 35) : BoxConstraints(maxWidth: 70),
                          child: Container(
                            child: Text(
                              listChannels[index].channelName,
                              style: TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sortDropdown() {
    _dropDownMenuItems = getDropDownMenuItems();
    _sortingMethod = _dropDownMenuItems[1].value;

    return Container(
      height: isScrollingDown ? 0 : 36,
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          MyIcons.sortIcon,
          spaceLeft,
          DropdownButton<String>(
            icon: MyIcons.sortDownIcon,
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

  Widget _channelsVideoListView() {
    _getVideos();
    return Expanded(
      child: SmartRefresher(
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
          itemCount: listVideos.length,
          // ignore: missing_return
          itemBuilder: (context, index) {
            return _videosCart(index, MediaQuery.of(context).size.width);
          }
        ),
      ),
    );
  }

  /// 구독한 채널이 있을 경우
  Widget _hasChannels() {
    return Column(
      children: [
        _favoriteChannelList(),
        _sortDropdown(),
        _channelsVideoListView(),
      ],
    );
  }

  /// 구독한 채널이 없을 경우
  Widget _searchChannel() {
    return RandomChannelListPage(scrollController: _scrollController);
  }

  void _getSubscribeChannels() {
    Future<List<Channels>> futureChannels = FavoriteChannelsDb().getAllChannels();
    futureChannels.then((value) {setState(() {
      listChannels = value;
    });});
  }

  void _getVideos() {
    videosResponse = server.getByChannelIdSort(_listToString(listChannels), sort, 1, count);
    videosResponse.then((value) {setState(() {
      listVideos.addAll(value);
    });});
  }

  @override
  void initState() {
    super.initState();
    _getSubscribeChannels();

    /// appbar setting
    _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (listChannels == null) {
      return Center(child: CupertinoActivityIndicator(),);
    } else {
      return Scaffold(
        body: MyAnimatedAppBar(
          scrollController: _scrollController,
          child: MyAppBar(),
          body: Expanded(
            child: CheckNetwork(
              body: listChannels.length == 0 ? _searchChannel() : _hasChannels(),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.keyboard_arrow_up),
              onPressed: () => _scrollController.animateTo(0.0, duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn),
            ),
          ],
        ),
      );
    }

  }

}

