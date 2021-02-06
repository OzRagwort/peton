
import 'package:flutter/material.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:peton/widgets/KeywordsLatelyHit.dart';
import 'package:peton/widgets/KeywordsGridview.dart';
import 'package:peton/widgets/KeywordsPopularChannels.dart';
import 'package:peton/widgets/KeywordsRecommend.dart';
import 'package:peton/widgets/KeywordsSmallChannels.dart';
import 'package:peton/widgets/Line.dart';
import 'package:peton/widgets/MyAnimatedAppBar.dart';
import 'package:peton/widgets/MyAppBar.dart';

class KeywordsPage extends StatefulWidget {
  @override
  _KeywordsPageState createState() => _KeywordsPageState();
}

class _KeywordsPageState extends State<KeywordsPage> {

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: MyAnimatedAppBar(
        scrollController: _scrollController,
        child: MyAppBar(),
        body: Expanded(
          child: CheckNetwork(
            body: ListView(
              children: [
                Text("최근 인기 영상", textAlign: TextAlign.center),
                // KeywordsLatelyHit(),
                divline,
                // KeywordsGridview(width, context),
                divline,
                Text("추천 영상", textAlign: TextAlign.center),
                // KeywordsRecommend(),
                divline,
                Text("인기 채널", textAlign: TextAlign.center),
                // KeywordsPopularChannels(),
                divline,
                Text("소규모 채널", textAlign: TextAlign.center),
                // KeywordsSmallChannels()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

