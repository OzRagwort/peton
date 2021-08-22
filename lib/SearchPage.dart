
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/enums/CategoryId.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> listVideos = new List<VideosResponse>();

  String keyword = '';
  int size = 20;
  String category = CategoryId.id;
  bool pullUp = true;

  void _onLoading() async{
    _getSearchVideos();

    _refreshController.loadComplete();
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

  void _getSearchVideos() {
    int page = listVideos.length ~/ size;

    listVideos = new List<VideosResponse>();
    Map<String, String> paramMap = {
      'categoryId' : category,
      'search' : keyword,
      'size' : size.toString(),
      'page' : page.toString()
    };
    videosResponse = server.getVideoByParam(paramMap);
    videosResponse.then((value) {setState(() {
      if (value.length < size) {
        pullUp = false;
      }
      listVideos.addAll(value);
    });});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.lightBlueAccent,
        centerTitle: true,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  keyword = value;
                  _getSearchVideos();
                },
              ),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Icon(Icons.search),
            onPressed: () {
              keyword = textController.text;
              _getSearchVideos();
            },
          ),
        ],
      ),
      body: CheckNetwork(
        body: SmartRefresher(
          enablePullDown: false,
          enablePullUp: pullUp ? true : false,
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
          onLoading: _onLoading,
          child: ListView.builder(
              itemCount: listVideos.length,
              itemBuilder: (context, index) {
                return _videosCard(index, MediaQuery.of(context).size.width);
              }
          ),
        ),
      ),
    );
  }
}
