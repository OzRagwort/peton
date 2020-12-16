import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peton/database/FavoriteChannelsDb.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/widgets/AnimatedAppBar.dart';
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

  bool isDisposed = false;

  /// hide appbar
  ScrollController _scrollController;

  /// 구독 채널들 저장 변수
  List<Channels> listChannels = new List<Channels>();

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

  void _onRefresh() async {

    listVideos = new List<VideosResponse>();
    videosResponse = server.getbyChannelIdSortDate(_listToString(listChannels), sort, 1, count);

    videosResponse.then((value) => setState(() {listVideos.addAll(value);}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {

    int index = (listVideos.length ~/ 10) + 1;

    videosResponse = server.getbyChannelIdSortDate(_listToString(listChannels), sort, index, count);
    videosResponse.then((value) => listVideos.addAll(value));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  void _sortRefresh(String index) async {
    if (index == _sortList[0]) {
      sort = 'popular';
    } else if (index == _sortList[1]) {
      sort = 'desc';
    } else {
      sort = 'asc';
    }

    listVideos = new List<VideosResponse>();
    videosResponse = server.getbyChannelIdSortDate(_listToString(listChannels), sort, 1, count);
    videosResponse.then((value) {
      listVideos.addAll(value);
      setState(() {});
    });
  }

  void _onClickChannel(int index) async {

    log('onChilckChannel : ' + index.toString());

    _channelClickCheck = index;
    listVideos = new List<VideosResponse>();
    videosResponse = server.getbyChannelIdSortDate(listChannels[index].channelId, sort, 1, count);

    videosResponse.then((value) => setState(() {listVideos.addAll(value);}));
  }

  void _offClickChannel(int index) async {

    log('offChilckChannel : ' + index.toString());

    _channelClickCheck = null;
    _onRefresh();
  }

  Widget _videosCart(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideowatchPage(videoId: listVideos[listNum].videoId)),
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

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _sortingMethod = _dropDownMenuItems[1].value;
    videosResponse = server.getbyChannelIdSortDate(_listToString(listChannels), sort, 1, count);

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

    return Scaffold(
        body: AnimatedAppBar(
          scrollController: _scrollController,
          child: myAppbar(),
          body: Expanded(
            child: FutureBuilder<List<Channels>>(
              future: FavoriteChannelsDb().getAllChannels(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  listChannels = snapshot.data;

                  return Column(
                    children: [

                      /// 좋아요 채널 리스트
                      // FavoriteChannelsListBuilder(),
                      Container(
                        // margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 125,
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
                      ),

                      /// 정렬 박스
                      Container(
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontFamily: 'NotoSerifKR',
                                fontWeight: FontWeight.w400,
                              ),
                              underline: Container(height: 0),
                              items: _dropDownMenuItems,
                              onChanged: (String newValue) {
                                _sortingMethod = newValue;
                                _sortRefresh(newValue);
                              },
                            ),
                          ],
                        ),
                      ),

                      /// 리스트 뷰
                      Expanded(
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
                              itemCount: listVideos.length + 10,
                              // ignore: missing_return
                              itemBuilder: (context, index) {
                                // log(listVideos.length.toString() + ' / ' + index.toString());
                                if (index == 0 && listVideos.length == 0) {
                                  videosResponse = server.getbyChannelIdSortDate(_listToString(listChannels), sort, 1, count);
                                  return FutureBuilder<List<VideosResponse>>(
                                    future: videosResponse,
                                    // future: server.getbyChannelIdSortDate(_listToString(), sort, 1, count),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        listVideos.addAll(snapshot.data);
                                        return _videosCart(index, MediaQuery.of(context).size.width);
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return Center(
                                        child: Image.asset(
                                          "lib/assets/spinner.gif",
                                          fit: BoxFit.fill,
                                        ),
                                      );
                                    },
                                  );
                                }
                                if (listVideos.length > index) {
                                  return _videosCart(index, MediaQuery.of(context).size.width);
                                }
                              }
                          ),
                        ),
                      ),

                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
        ),
    );

  }

}

