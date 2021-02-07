
import 'package:flutter/material.dart';
import 'package:peton/KeywordsLatelyHitPage.dart';
import 'package:peton/KeywordsRecommendPage.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:peton/widgets/KeywordsLatelyHit.dart';
import 'package:peton/widgets/KeywordsGridView.dart';
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
                /// 최근 인기 영상
                InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KeywordsLatelyHitPage()),
                    )
                  },
                  child: Text(
                    "최근 인기 영상",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
                KeywordsLatelyHit(),
                divline,

                /// 그리드뷰
                KeywordsGridView(width, context),
                divline,

                /// 추천 영상
                InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KeywordsRecommendPage()),
                    )
                  },
                  child: Text(
                    "추천 영상",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
                KeywordsRecommend(),
                divline,

                /// 인기 채널
                Text("인기 채널", textAlign: TextAlign.center),
                KeywordsPopularChannels(),
                divline,

                /// 소규모 채널
                Text("소규모 채널", textAlign: TextAlign.center),
                KeywordsSmallChannels()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

