
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/CarouselWithIndicatorVideos.dart';

class KeywordsLatelyHit extends StatefulWidget {
  @override
  _KeywordsLatelyHitState createState() => _KeywordsLatelyHitState();
}

class _KeywordsLatelyHitState extends State<KeywordsLatelyHit> {

  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> hitList = new List<VideosResponse>();

  int hour = 24;
  int category = 1;
  String sort = "popular";
  int page = 1;
  int count = 15;

  @override
  void initState() {
    super.initState();
    videosResponse = server.getVideosByPublishedDate(hour, category, sort, false, page, count);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: videosResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          hitList.addAll(snapshot.data);
          return CarouselWithIndicatorVideos(videos: hitList);
        } else if (snapshot.hasError) {
          print(snapshot.error);
        }
        return Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}


