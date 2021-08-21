
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/enums/CategoryId.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KeywordsLatelyPage extends StatefulWidget {
  KeywordsLatelyPage({this.popularVideosList});

  final List<VideosResponse> popularVideosList;

  @override
  _KeywordsLatelyPageState createState() => _KeywordsLatelyPageState();
}

class _KeywordsLatelyPageState extends State<KeywordsLatelyPage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<List<VideosResponse>> latelyVideosResponse;
  List<VideosResponse> latelyVideosList = new List<VideosResponse>();

  int page = 0;
  Map<String, String> paramMap = {
    'categoryId' : CategoryId.id,
    'sort' : 'videoPublishedDate,desc',
    'size' : '10',
    'page' : '0'
  };

  void _onRefresh() {

    latelyVideosList = new List<VideosResponse>();
    page = 0;
    paramMap['page'] = page.toString();

    _getLatelyVideos();

    _refreshController.refreshCompleted();
  }

  void _onLoading() {

    page++;
    paramMap['page'] = page.toString();

    _getLatelyVideos();

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
  }

  Widget _videosCard(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: latelyVideosList[listNum].videoId)),
        )
      },
      child: videoCard(latelyVideosList[listNum], width),
    );
  }

  void _getLatelyVideos() {
    latelyVideosResponse = server.getVideoByParam(paramMap);
    latelyVideosResponse.then((value) => setState(() {latelyVideosList.addAll(value);}));
  }

  @override
  void initState() {
    super.initState();
    _getLatelyVideos();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("실시간 업로드 영상"),
        centerTitle: false,
      ),
      body: CheckNetwork(
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: MaterialClassicHeader(),
          footer: CustomFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("더보기");
              }
              else if(mode==LoadStatus.loading){
                body =  CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("로딩 재시도");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("더보기");
              }
              else{
                body = Text("");
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
              itemCount: latelyVideosList.length,
              itemBuilder: (context, index) {
                return _videosCard(index, width);
              }
          ),
        ),
      ),
    );
  }
}

