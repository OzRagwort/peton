
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/MainPage.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/FavoriteIconBuilder.dart';
import 'package:peton/widgets/Line.dart';
import 'package:peton/widgets/TextForm.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'Server.dart';
import 'VideoplayerPage.dart';
import 'function/channelSubscriberCountCheck.dart';
import 'model/VideosResponse.dart';

class ChannelInfoPage extends StatefulWidget {
  ChannelInfoPage({this.channel});

  final channel;

  @override
  _ChannelInfoPageState createState() => _ChannelInfoPageState(channel: channel);
}

class _ChannelInfoPageState extends State<ChannelInfoPage> {
  _ChannelInfoPageState({this.channel});

  Channels channel;
  String sort = 'desc'; // 최신순
  int count = 10;

  List<String> _sortList = ['인기 동영상', '최신 순', '오래된 순'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _sortingMethod;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> myList = new List<VideosResponse>();

  void _onRefresh() async{

    myList = new List<VideosResponse>();
    videosResponse = server.getbyChannelIdSortDate(channel.channelId, sort, 1, count);

    videosResponse.then((value) => setState(() {myList.addAll(value);}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async{

    int index = (myList.length ~/ 10) + 1;

    videosResponse = server.getbyChannelIdSortDate(channel.channelId, sort, index, count);
    videosResponse.then((value) => myList.addAll(value));

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

    myList = new List<VideosResponse>();
    videosResponse = server.getbyChannelIdSortDate(channel.channelId, sort, 1, count);
    videosResponse.then((value) {
      myList.addAll(value);
      setState(() {});
    });
  }

  Widget _videosCartSmall(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideowatchPage(videoId: myList[listNum].videoId)),
        )
      },
      child: videoCard(myList[listNum], width),
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
    videosResponse = server.getbyChannelIdSortDate(channel.channelId, sort, 1, count);
  }

  @override
  Widget build(BuildContext context) {
    int _selectedTabIndex = 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          title: Text(''),
          backgroundColor: Colors.white,
        ),
      ),


      body:
      Column(
        children: [
          /// 상단 채널 정보
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                channelThumbnailCircle(channel.channelThumbnail, MediaQuery.of(context).size.width / 10),
                verticalDivline,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Expanded(
                      //   child: Text('title'),
                      // ),
                      textTitle(channel.channelName, 20.0),
                      space,
                      textTitle(ChannelSubscriberSountCheck(channel.subscribers), 15.0),
                    ],
                  ),
                ),
                FavoriteIconBuilder(channels: channel,),
              ],
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
                  itemCount: myList?.length + 10,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    // log(myList.length.toString() + ' / ' + index.toString());
                    if (index == 0 && myList.length == 0) {
                      return FutureBuilder<List<VideosResponse>>(
                        future: videosResponse,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            myList.addAll(snapshot.data);
                            return _videosCartSmall(index, MediaQuery.of(context).size.width);
                          } else if (snapshot.hasError) {
                            log('futurebuilder_list<v> error');
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
                    if (myList.length > index) {
                      return _videosCartSmall(index, MediaQuery.of(context).size.width);
                    }
                  }
              ),
            ),
          ),

        ],
      ),



      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Favorite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            title: Text('Library'),
          ),
        ],
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainPage(title: 'PetON', index: index,),
            ),
                (route) => false,
          );
        },
      ),
    );
  }
}
