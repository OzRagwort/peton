import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:peton/Server.dart';
import 'package:peton/database/LibraryVideosDb.dart';
import 'package:peton/model/LibraryVideos.dart';
import 'package:peton/widgets/Cards.dart';

import 'model/VideosResponse.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<LibraryVideos>>(
        future: LibraryVideosDb().getAllLibraryVideos(),
        // builder: (BuildContext context, AsyncSnapshot<List<LibraryVideos>> snapshot) {
        builder: (context, snapshot) {

          if(snapshot.hasData) {

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {

                LibraryVideos item = snapshot.data[index];

                VideosResponse videosResponse = item.toVideosResponse();

                return videoCardSmall(videosResponse, MediaQuery.of(context).size.width);

                // return Dismissible(
                //   key: UniqueKey(),
                //   onDismissed: (direction) {
                //     LibraryVideosDb().deleteLibraryVideo(item.videoId);
                //     setState(() {});
                //   },
                //   child: Center(child: Text(item.videoName)),
                // );
              },
            );
          }
          else
          {
            return Center(child: CircularProgressIndicator(),);
          }
        },
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


