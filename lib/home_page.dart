import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:peton/Server.dart';

import 'model/VideosResponse.dart';
import 'widgets/line.dart';
import 'widgets/cards.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  List<VideosResponse> myList;
  // List<String> addList = <String>['Add1','Add2','Add3','Add4','Add5'];

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _setup() async {


    FutureBuilder(
      future: server.getReq('RGsIiuf-6Zg'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // myList.add(snapshot.data);
        setState(() {
          myList.add(snapshot.data);
        });
        return snapshot.data;
      },
    );

    // setState(() {});
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    setState(() {});

    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // myList.addAll(addList);

    await FutureBuilder(
      future: server.getReq('RGsIiuf-6Zg'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        myList.add(snapshot.data);
        setState(() {});
        return null;
      },
    );

    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    log('start');
    _setup();

    // 썸네일, 제목, 채널, 시간, 채널썸네일, 보관함여부

    return Scaffold(
      // body: _buildSuggestions(),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context,LoadStatus mode){
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
            // itemCount: myList?.length+1,
            itemCount: 10,
            itemBuilder: (context, index) {
              log(index.toString());
              // if(myList.length == index) {
              //   return RaisedButton(
              //       onPressed: () {
              //         myList.add('value');
              //         setState(() {});
              //       }
              //   );
              // }
              if (myList.length != 0){
                return videoCard(myList[index], width);
              }
              return Text(myList[index].videoName);
            }
        ),
      )
    );
  }

}
