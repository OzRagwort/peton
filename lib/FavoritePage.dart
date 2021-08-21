
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

  /// hide appbar
  ScrollController _scrollController;

  /// 구독 채널들 저장 변수
  List<Channels> listChannels;

  /// 페이지 인덱스
  int pageIndex = 0;

  /// 정렬 관련, count 관련 변수
  List<String> _sortList = ['인기 동영상', '최신 순', '오래된 순'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _sortingMethod;
  String sort = 'videoPublishedDate,desc'; // 최신순
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
    Map<String, String> paramMap = {
      'channelId' : _listToString(listChannels),
      'sort' : sort,
      'size' : count.toString(),
      'page' : '0'
    };
    videosResponse = server.getVideoByParam(paramMap);
    videosResponse.then((value) => setState(() {listVideos = value;}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() {

    int index = (listVideos.length ~/ 10);

    Map<String, String> paramMap = {
      'channelId' : _listToString(listChannels),
      'sort' : sort,
      'size' : count.toString(),
      'page' : index.toString()
    };
    videosResponse = server.getVideoByParam(paramMap);
    videosResponse.then((value) => listVideos.addAll(value));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  void _sortRefresh(String index) {
    if (index == _sortList[0]) {
      sort = 'viewCount,desc';
    } else if (index == _sortList[1]) {
      sort = 'videoPublishedDate,desc';
    } else {
      sort = 'videoPublishedDate,asc';
    }

    listVideos = new List<VideosResponse>();
    Map<String, String> paramMap = {
      'channelId' : _listToString(listChannels),
      'sort' : sort,
      'size' : count.toString(),
      'page' : '0'
    };
    videosResponse = server.getVideoByParam(paramMap);
    videosResponse.then((value) {setState(() {
        listVideos = value;
      });});
  }

  void _onClickChannel(int index) {
    _channelClickCheck = index;
    listVideos = new List<VideosResponse>();
    Map<String, String> paramMap = {
      'channelId' : _listToString(listChannels),
      'sort' : sort,
      'size' : count.toString(),
      'page' : '0'
    };
    videosResponse = server.getVideoByParam(paramMap);
    videosResponse.then((value) {setState(() {
      listVideos = value;
    });});
  }

  void _offClickChannel(int index) async {
    _channelClickCheck = null;
    _onRefresh();
  }

  Widget _videosCard(int listNum, double width) {
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

  /// 구독 채널 리스트
  Widget _favoriteChannelList() {
    double heightSize = 127;

    return Container(
      alignment: Alignment.topLeft,
      height: heightSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        itemCount: listChannels.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                opacity: (_channelClickCheck == null) || (_channelClickCheck == index) ? 1.0 : 0.4,
                child: Container(
                  child: Column(
                    children: [
                      channelThumbnailCircle(listChannels[index].channelThumbnail, 35),
                      space,
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 70),
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
    );
  }

  /// 영상 정렬 방식
  Widget _sortDropdown() {
    return Container(
      height: 36,
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

  /// 채널 검색
  Widget _pushChannelsListPage() {
    return Container(
      height: 36,
      padding: const EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      child: RaisedButton(
        onPressed: () {
          setState(() {
            pageIndex = 0;
          });
        },
        color: Colors.transparent,
        elevation: 0,
        child: Text("채널 검색", style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyText1.color),),
      ),
    );
  }

  /// 구독한 채널이 있을 경우
  Widget _hasChannels() {
    if (listVideos.length == 0) {
      _getVideos();
    }
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
          itemCount: listVideos.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _favoriteChannelList();
            } else if (index == 1) {
              return Row(
                children: [
                  Expanded(child: _sortDropdown(),),
                  _pushChannelsListPage(),
                ],
              );
            } else {
              return _videosCard(index - 2, MediaQuery.of(context).size.width);
            }
          }
      ),
    );
  }

  /// 구독한 채널이 없을 경우
  Widget _searchChannel() {
    return RandomChannelListPage(scrollController: _scrollController);
  }

  /// 구독 채널 불러오기
  void _getSubscribeChannels() {
    Future<List<Channels>> futureChannels = FavoriteChannelsDb().getAllChannels();
    futureChannels.then((value) {setState(() {
      listChannels = value;
      if (value.length == 0) {
        pageIndex = 0;
      } else {
        pageIndex = 1;
      }
    });});
  }

  /// 구독 채널의 영상 불러오기
  void _getVideos() {
    Map<String, String> paramMap = {
      'channelId' : _listToString(listChannels),
      'sort' : sort,
      'size' : count.toString(),
      'page' : '0'
    };
    videosResponse = server.getVideoByParam(paramMap);
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

    _dropDownMenuItems = getDropDownMenuItems();
    _sortingMethod = _dropDownMenuItems[1].value;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              body: _buildPage(),
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

  Widget _buildPage(){
    if(pageIndex == 0) {
      return _searchChannel();
    } else {
      return _hasChannels();
    }
  }

}

