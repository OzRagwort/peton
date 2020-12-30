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

  void insertLib() {

    var getData = server.getRandbyCategoryId('1', 1);
    getData.then((value) => setState(() {
      libraryVideos = LibraryVideos(
        channelId : value[0].channels.channelId,
        channelName : value[0].channels.channelName,
        channelThumbnail : value[0].channels.channelThumbnail,
        videoId : value[0].videoId,
        videoName : value[0].videoName,
        videoThumbnail : value[0].videoThumbnail,
        videoPublishedDate : value[0].videoPublishedDate,
        videoEmbeddable : value[0].videoEmbeddable,
      );
      LibraryVideosDb().insertLibraryVideo(libraryVideos);
    }));

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

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
      body: MyAnimatedAppBar(
        scrollController: _scrollController,
        child: MyAppBar(),
        body: Expanded(
          child: CheckNetwork(
            body: FutureBuilder<List<LibraryVideos>>(
              future: LibraryVideosDb().getAllLibraryVideos(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  listVideos = snapshot.data;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _videosCartSmall(index, MediaQuery.of(context).size.width);
                    },
                  );
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            // heroTag: 'libDelBtn',
            heroTag: null,
            child: Icon(Icons.delete),
            onPressed: () {
              //모두 삭제 버튼
              log('deleteAll');
              LibraryVideosDb().deleteAllLibraryVideos();
              setState(() {});
            },
          ),
          SizedBox(height: 8.0),
          FloatingActionButton(
            // heroTag: 'libRefBtn',
            heroTag: null,
            child: Icon(Icons.refresh),
            onPressed: () {
              //새로고침
              log('refresh');
              setState(() {});
            },
          ),
          SizedBox(height: 8.0),
          FloatingActionButton(
            // heroTag: 'libAddBtn',
            heroTag: null,
            child: Icon(Icons.add),
            onPressed: () {
              //추가 버튼
              log('insert');
              insertLib();
              // setState(() {});
            },
          ),
        ],
      ),
    );
  }
}


