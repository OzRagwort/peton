
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/CarouselWithIndicatorVideos.dart';

class KeywordsRecommend extends StatefulWidget {
  KeywordsRecommend({this.recommendList});

  final List<VideosResponse> recommendList;

  @override
  _KeywordsRecommendState createState() => _KeywordsRecommendState();
}

class _KeywordsRecommendState extends State<KeywordsRecommend> {

  List<VideosResponse> recommendList = new List<VideosResponse>();

  @override
  void initState() {
    super.initState();
    recommendList = widget.recommendList;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselWithIndicatorVideos(videos: recommendList);
  }
}



