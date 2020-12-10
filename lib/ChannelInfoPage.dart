
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/MainPage.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/widgets/Cards.dart';
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

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> myList = new List<VideosResponse>();

  void _onRefresh() async{

    myList = new List<VideosResponse>();
    videosResponse = server.getbyChannelIdSortDate(channel.channelId, 'asc', 1, 10);

    videosResponse.then((value) => setState(() {myList.addAll(value);}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async{

    int index = (myList.length ~/ 10) + 1;

    videosResponse = server.getbyChannelIdSortDate(channel.channelId, 'asc', index, 10);
    videosResponse.then((value) => myList.addAll(value));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
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

  @override
  void initState() {
    super.initState();
    videosResponse = server.getbyChannelIdSortDate(channel.channelId, 'asc', 1, 10);
  }

  @override
  Widget build(BuildContext context) {
    int _selectedTabIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('titleChannel'),
      ),


      body:
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                channelThumbnailCircle(channel.channelThumbnail, MediaQuery.of(context).size.width / 8),
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
                Icon(
                  Icons.star,
                  size: 35,
                ),
              ],
            ),
          ),

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
                    log(myList.length.toString() + ' / ' + index.toString());
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


      // /// 채널의 영상 listview
      // SmartRefresher(
      //   enablePullDown: true,
      //   enablePullUp: true,
      //   header: MaterialClassicHeader(),
      //   footer: CustomFooter(
      //     loadStyle: LoadStyle.ShowWhenLoading,
      //     builder: (BuildContext context,LoadStatus mode){
      //       Widget body ;
      //       /// 로드 완료 후
      //       if(mode==LoadStatus.idle){
      //         body =  Text("pull up load");
      //       }
      //       /// ?
      //       else if(mode==LoadStatus.loading){
      //         body =  CupertinoActivityIndicator();
      //       }
      //       /// ?
      //       else if(mode == LoadStatus.failed){
      //         body = Text("Load Failed!Click retry!");
      //       }
      //       /// 로드하려고 풀업했을 때 나타는 것
      //       else if(mode == LoadStatus.canLoading){
      //         body = Text("Load more");
      //       }
      //       /// ?
      //       else{
      //         body = Text("No more Data");
      //       }
      //       return Container(
      //         height: 55.0,
      //         child: Center(child:body),
      //       );
      //     },
      //   ),
      //   controller: _refreshController,
      //   onRefresh: _onRefresh,
      //   onLoading: _onLoading,
      //   child: Column(
      //     children: [
      //       Container(
      //         padding: const EdgeInsets.all(16),
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: <Widget>[
      //             channelThumbnailCircle(channel.channelThumbnail, MediaQuery.of(context).size.width / 8),
      //             verticalDivline,
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: <Widget>[
      //                   // Expanded(
      //                   //   child: Text('title'),
      //                   // ),
      //                   textTitle(channel.channelName, 20.0),
      //                   space,
      //                   textTitle(ChannelSubscriberSountCheck(channel.subscribers), 15.0),
      //                 ],
      //               ),
      //             ),
      //             Icon(
      //               Icons.star,
      //               size: 35,
      //             ),
      //           ],
      //         ),
      //       ),
      //       Expanded(
      //         child: ListView.builder(
      //             itemCount: myList?.length + 10,
      //             // ignore: missing_return
      //             itemBuilder: (context, index) {
      //               log(myList.length.toString() + ' / ' + index.toString());
      //               if (index == 0 && myList.length == 0) {
      //                 return FutureBuilder<List<VideosResponse>>(
      //                   future: videosResponse,
      //                   builder: (context, snapshot) {
      //                     if (snapshot.hasData) {
      //                       myList.addAll(snapshot.data);
      //                       return _videosCartSmall(index, MediaQuery.of(context).size.width);
      //                     } else if (snapshot.hasError) {
      //                       log('futurebuilder_list<v> error');
      //                       return Text("${snapshot.error}");
      //                     }
      //                     return Center(
      //                       child: Image.asset(
      //                         "lib/assets/spinner.gif",
      //                         fit: BoxFit.fill,
      //                       ),
      //                     );
      //                   },
      //                 );
      //               }
      //               if (myList.length > index) {
      //                 return _videosCartSmall(index, MediaQuery.of(context).size.width);
      //               }
      //             }
      //         ),
      //       ),
      //
      //     ],
      //   ),
      // ),



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
