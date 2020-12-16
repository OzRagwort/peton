import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peton/Server.dart';
import 'package:peton/database/LibraryVideosDb.dart';
import 'package:peton/model/LibraryVideos.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/ScrollAppBar.dart';

import 'model/VideosResponse.dart';

class LibraryPage extends StatefulWidget {
  LibraryPage({Key key, this.scrollAppBarController}) : super(key: key);

  final ScrollAppBar scrollAppBarController;

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

  /// hide appbar
  ScrollAppBar scrollAppBarController;
  ScrollController _scrollController;

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

  void scrollControllerAddListener() {
    _scrollController.addListener (() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!scrollAppBarController.isScrollingDown) {
          scrollAppBarController.isScrollingDown = true;
          scrollAppBarController.showAppbar = false;
          setState (() {});
        }
      }

      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (scrollAppBarController.isScrollingDown) {
          scrollAppBarController.isScrollingDown = false;
          scrollAppBarController.showAppbar = true;
          setState (() {});
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    /// appbar setting
    scrollAppBarController = widget.scrollAppBarController;
    _scrollController = scrollAppBarController.scrollViewController;
    scrollControllerAddListener();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    log('Library Dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            height: scrollAppBarController.showAppbar ? 48.0 : 0.0,
            duration: Duration(milliseconds: 100),
            child: AppBar(
              backgroundColor: Colors.white,
              title: Center(
                child: Text(
                  'title',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              actions: <Widget>[
                //add buttons here
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<LibraryVideos>>(
              future: LibraryVideosDb().getAllLibraryVideos(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      LibraryVideos item = snapshot.data[index];
                      VideosResponse videosResponse = item.toVideosResponse();
                      return videoCardSmall(videosResponse, MediaQuery.of(context).size.width);
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
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
            child: Icon(Icons.refresh),
            onPressed: () {
              //새로고침
              log('refresh');
              setState(() {});
            },
          ),
          SizedBox(height: 8.0),
          FloatingActionButton(
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


