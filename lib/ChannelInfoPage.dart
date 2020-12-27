
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/MainPage.dart';
import 'package:peton/NetworkErrorPage.dart';
import 'package:peton/enums/MyIcons.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CheckNetwork.dart';
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
  String sort = 'desc'; // 최신순 desc:최신, asc:오래된순, popular:인기순
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
    videosResponse = server.getbyChannelIdSort(channel.channelId, sort, 1, count);

    videosResponse.then((value) => setState(() {myList.addAll(value);}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async{

    int index = (myList.length ~/ 10) + 1;

    videosResponse = server.getbyChannelIdSort(channel.channelId, sort, index, count);
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
    videosResponse = server.getbyChannelIdSort(channel.channelId, sort, 1, count);
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
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: myList[listNum].videoId)),
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
    videosResponse = server.getbyChannelIdSort(channel.channelId, sort, 1, count);
  }

  @override
  Widget build(BuildContext context) {
    int _selectedTabIndex = 0;

    return CheckNetwork(
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            title: Text(''),
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
                        textTitle(ChannelSubscriberCountCheck(channel.subscribers), 15.0),
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
                      if (index == 0 && myList.length == 0) {
                        return FutureBuilder<List<VideosResponse>>(
                          future: videosResponse,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              myList.addAll(snapshot.data);
                              return _videosCartSmall(index, MediaQuery.of(context).size.width);
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
                      if (myList.length > index) {
                        return _videosCartSmall(index, MediaQuery.of(context).size.width);
                      }
                    }
                ),
              ),
            ),

          ],
        ),



        bottomNavigationBar: SizedBox(
          height: 50,
          child: BottomNavigationBar(
            iconSize: 21,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _selectedTabIndex == 0 ? MyIcons.homePageIconFill : MyIcons.homePageIcon,
                title: Text('Home', style: TextStyle(fontSize: 12),),
              ),
              BottomNavigationBarItem(
                icon: _selectedTabIndex == 1 ? MyIcons.favoritePageIconFill : MyIcons.favoritePageIcon,
                title: Text('Favorite', style: TextStyle(fontSize: 12),),
              ),
              BottomNavigationBarItem(
                icon: _selectedTabIndex == 2 ? MyIcons.libraryPageIconFill : MyIcons.libraryPageIcon,
                title: Text('Library', style: TextStyle(fontSize: 12),),
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
        ),
      ),
      error: NetworkErrorPage(),
    );
  }
}
