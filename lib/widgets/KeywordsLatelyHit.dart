
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/CarouselWithIndicatorVideos.dart';

class KeywordsLatelyHit extends StatefulWidget {
  KeywordsLatelyHit({this.latelyList});

  final List<VideosResponse> latelyList;

  @override
  _KeywordsLatelyHitState createState() => _KeywordsLatelyHitState();
}

class _KeywordsLatelyHitState extends State<KeywordsLatelyHit> {

  List<VideosResponse> latelyList = new List<VideosResponse>();

  @override
  void initState() {
    super.initState();
    latelyList = widget.latelyList;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselWithIndicatorVideos(videos: latelyList);
  }
}


