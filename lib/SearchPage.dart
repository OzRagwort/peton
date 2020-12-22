
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
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

  String keyword;

  void _onLoading() async{

    int index = (listVideos.length ~/ 10) + 1;

    videosResponse = server.getSearchVideos(keyword, index, 10);
    videosResponse.then((value) => listVideos.addAll(value));

    if(mounted)
      setState(() {});

    _refreshController.loadComplete();
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

  void _getSearchVideos() {
    setState(() {
      listVideos = new List<VideosResponse>();
    });
    videosResponse = server.getSearchVideos(keyword, 1, 10);
    videosResponse.then((value) => setState(() => listVideos = value));
  }

  @override
  void initState() {
    super.initState();
    keyword = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.lightBlueAccent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
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
      body: SmartRefresher(
        enablePullDown: false,
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
        onLoading: _onLoading,
        child: ListView.builder(
            itemCount: listVideos.length,
            itemBuilder: (context, index) {
              return _videosCart(index, MediaQuery.of(context).size.width);
            }
        ),
      ),
    );
  }
}
