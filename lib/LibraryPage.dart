
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/database/LibraryVideosDb.dart';
import 'package:peton/model/LibraryVideos.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:peton/widgets/MyAnimatedAppBar.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/MyAppBar.dart';

class LibraryPage extends StatefulWidget {

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

  /// hide appbar
  ScrollController _scrollController;

  List<LibraryVideos> listVideos;
  LibraryVideos libraryVideos;

  /// 즐겨찾기한 영상이 없을 경우
  Widget _emptyLibrary() {
    return Center(
      child: Text("즐겨찾기한 영상이 없습니다."),
    );
  }

  Widget _videosCardSmall(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: listVideos[listNum].videoId)),
        )
      },
      child: videoCardSmall(listVideos[listNum].toVideosResponse(), width),
    );
  }

  void _getLibraryVideos() {
    Future<List<LibraryVideos>> futureLibrary = LibraryVideosDb().getAllLibraryVideos();
    futureLibrary.then((value) {setState(() {
      listVideos = value;
    });});
  }

  @override
  void initState() {
    super.initState();
    _getLibraryVideos();

    /// appbar setting
    _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (listVideos == null) {
      return Center(child: CupertinoActivityIndicator(),);
    }
    else {
      return Scaffold(
        body: MyAnimatedAppBar(
          scrollController: _scrollController,
          child: MyAppBar(),
          body: Expanded(
            child: CheckNetwork(
              body: listVideos.length == 0
                  ? _emptyLibrary()
                  : Container(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: listVideos.length,
                  itemBuilder: (BuildContext contextItemBuilder, int index) {
                    return Dismissible(
                      key: Key(listVideos[index].videoId),
                      onDismissed: (direction) {
                        LibraryVideos buf = listVideos[index];
                        setState(() {
                          LibraryVideosDb().deleteLibraryVideo(listVideos[index].videoId);
                          listVideos.removeAt(index);
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text('삭제 취소됨', style: TextStyle(fontSize: 18, color: Colors.white),),
                              ));
                              LibraryVideosDb().insertLibraryVideo(buf);
                              _getLibraryVideos();
                            },
                            label: '취소',
                            textColor: Colors.red,
                          ),
                          content: Text('보관함에서 영상 삭제', style: TextStyle(fontSize: 18, color: Colors.white),),
                        ));
                      },
                      child: _videosCardSmall(index, MediaQuery.of(context).size.width - 20),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}


