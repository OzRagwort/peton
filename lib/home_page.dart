import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:peton/videowatch_page.dart';
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

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> myList = new List<VideosResponse>();

  void _onRefresh() async{

    myList = new List<VideosResponse>();
    videosResponse = server.getRandbyCategoryId('1', 10);
    
    videosResponse.then((value) => setState(() {myList.addAll(value);}));

    _refreshController.refreshCompleted();
  }

  void _onLoading() async{

    videosResponse = server.getRandbyCategoryId('1', 10);
    videosResponse.then((value) => myList.addAll(value));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  Widget _videosCart(int listNum, double width) {
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
    videosResponse = server.getRandbyCategoryId('1', 10);
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    // 썸네일, 제목, 채널, 시간, 채널썸네일, 보관함여부
    return Scaffold(
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
          itemCount: myList?.length + 10,
          // ignore: missing_return
          itemBuilder: (context, index) {
            log(myList.length.toString() + ' / ' + index.toString());
            if (index == 0) {
              return FutureBuilder<List<VideosResponse>>(
                future: videosResponse,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    myList.addAll(snapshot.data);
                    return _videosCart(index, width);
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
              return _videosCart(index, width);
            }
          }
        ),
      )
    );
  }

}
