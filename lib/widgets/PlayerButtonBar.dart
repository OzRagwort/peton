
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/AdMobManager.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/enums/MyIcons.dart';
import 'package:peton/function/LaunchYoutube.dart';
import 'package:peton/function/MyShare.dart';
import 'package:peton/function/ShortUrl.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/LibraryIconBuilder.dart';
import 'package:share/share.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerButtonBar extends StatelessWidget {
  PlayerButtonBar({this.videosResponse, this.nextVideo});

  VideosResponse videosResponse;
  String nextVideo;

  AdMobManager adMobManager = new AdMobManager();

  @override
  Widget build(BuildContext context) {
    adMobManager.initInterstitial();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 유튜브
          Column(
            children: [
              IconButton(
                icon: MyIcons.youtubeIcon,
                onPressed: () {
                  context.ytController.pause();
                  LaunchYoutube.openYoutube(videosResponse.videoId);
                },
              ),
              Text('유튜브 실행', style: TextStyle(fontSize: 12)),
            ],
          ),

          /// 다음 영상 재생
          Column(
            children: [
              IconButton(
                icon: MyIcons.skipNextIcon,
                onPressed: () {
                  context.ytController.pause();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: nextVideo)),
                  ).then((value) => context.ytController.play());
                },
              ),
              Text('다음 영상', style: TextStyle(fontSize: 12)),
            ],
          ),

          /// 재생/중지
          Column(
            children: [
              YoutubeValueBuilder(
                builder: (context, value) {
                  return IconButton(
                    icon: Icon(
                      value.playerState == PlayerState.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: value.isReady
                        ? () {
                      value.playerState == PlayerState.playing
                          ? context.ytController.pause()
                          : context.ytController.play();
                    }
                        : null,
                  );
                },
              ),
              Text(context.ytController.value.playerState == PlayerState.playing ? '일시정지' : '재생', style: TextStyle(fontSize: 12)),
            ],
          ),

          /// 공유하기
          Column(
            children: [
              IconButton(
                icon: MyIcons.shareIcon,
                onPressed: () {
                  var link = myShare.shareVideo(videosResponse);
                  link.then((shareLink) => {
                    shortUrl.getShortUrl(shareLink).then((shortLink) => Share.share(shortLink)),
                  });
                },
              ),
              Text('공유', style: TextStyle(fontSize: 12)),
            ],
          ),

          /// 저장하기
          Column(
            children: [
              LibraryListenableBuilder(videosResponse: videosResponse),
              Text('저장', style: TextStyle(fontSize: 12)),
            ],
          ),

        ],
      ),
    );
  }

}

