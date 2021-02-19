import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peton/Server.dart';
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

  Map<int, LibraryVideos> deleteBuffer = new Map<int, LibraryVideos>();

  }

  Widget _emptyLibrary() {
    return Center(
      child: Text("즐겨찾기한 영상이 없습니다."),
    );
  }

  Widget _videosCartSmall(int listNum, double width) {
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
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (listVideos == null) {
      return Center(child: CupertinoActivityIndicator(),);
    } else if (listVideos.length == 0) {
      return Scaffold(
        body: MyAnimatedAppBar(
          scrollController: _scrollController,
          child: MyAppBar(),
          body: Expanded(
            child: CheckNetwork(
              body: _emptyLibrary(),
            ),
          ),
        ),
      );
    } else {
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
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(listVideos[index].videoId),
                      onDismissed: (direction) {
                        setState(() {
                          Map<int, LibraryVideos> m = {index: listVideos[index]};
                          deleteBuffer.addAll(m);
                          LibraryVideosDb().deleteLibraryVideo(listVideos[index].videoId);
                          listVideos.removeAt(index);
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          content: Row(
                            children: [
                              Expanded(child: Text('보관함에서 영상 삭제', style: TextStyle(fontSize: 18, color: Color(Theme.of(context).textTheme.bodyText1.color.value)),),),
                              InkWell(
                                onTap: () {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text('삭제 취소됨', style: TextStyle(fontSize: 18, color: Color(Theme.of(context).textTheme.bodyText1.color.value)),),
                                  ));
                                  setState(() {
                                    LibraryVideosDb().insertLibraryVideo(deleteBuffer[index]);
                                    listVideos.add(deleteBuffer[index]);
                                  });
                                },
                                child: Text('취소', style: TextStyle(color: Colors.red),),
                              ),
                            ],
                          ),
                        ));
                      },
                      child: _videosCartSmall(index, MediaQuery.of(context).size.width - 20),
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


