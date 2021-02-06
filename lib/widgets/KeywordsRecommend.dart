
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/CarouselWithIndicatorVideos.dart';

class KeywordsRecommend extends StatefulWidget {
  @override
  _KeywordsRecommendState createState() => _KeywordsRecommendState();
}

class _KeywordsRecommendState extends State<KeywordsRecommend> {

  Future<List<VideosResponse>> videosResponse;
  List<VideosResponse> recommendList = new List<VideosResponse>();

  int category = 1;
  int page = 1;
  int count = 15;

  @override
  void initState() {
    super.initState();
    videosResponse = server.getVideosByScoreAvg(category, page, count);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: videosResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          recommendList.addAll(snapshot.data);
          return CarouselWithIndicatorVideos(videos: recommendList);
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



