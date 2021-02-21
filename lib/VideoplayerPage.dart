
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:peton/widgets/Line.dart';
import 'package:peton/widgets/PlayerButtonBar.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/VideoDataSection.dart';
import 'widgets/ChannelDataSection.dart';

import 'Server.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key key, this.videoId}) : super(key: key);

  final String videoId;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {

  /// 재생 영상 정보
  Future<VideosResponse> vidoesResponse;
  VideosResponse videos;
  String videoId;

  /// 해당 채널의 영상들
  Future<List<VideosResponse>> vidoesResponseByChannel;
  List<VideosResponse> videosByChannel;

  YoutubePlayerController _controller;

  void _getVideos() {
    vidoesResponseByChannel = server.getByChannelIdSort(videos.channels.channelId, 'asc', true, 1, 10);
    vidoesResponseByChannel.then((value) {setState(() {
      videosByChannel = value;
    });});
  }

  void _getData() {
    vidoesResponse = server.refreshGetVideo(videoId);
    vidoesResponse.then((value) {setState(() {
      videos = value;
      _getVideos();
    });});
  }

  @override
  void initState() {
    super.initState();
    videoId = widget.videoId;
    _getData();

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      params: const YoutubePlayerParams(
        autoPlay: true,
        interfaceLanguage: 'ko',
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        enableCaption: false,
        captionLanguage: 'ko',
        showVideoAnnotations: false,
        strictRelatedVideos: false,
        color: 'white',
      ),
    )..listen((value) {
      if (value.isReady && !value.hasPlayed) {
        _controller
          ..hidePauseOverlay()
          ..hideTopMenu();
        _controller.play();
      }
    });
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _controller.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      Future.delayed(const Duration(seconds: 1), () {
        _controller.play();
      });
      Future.delayed(const Duration(seconds: 5), () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();

    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        body: SafeArea(
          child: CheckNetwork(
            slidingUp: true,
            body: Column(
              children: [
                player,
                Expanded(
                  child: YoutubeValueBuilder(
                    builder: (context, value) {
                      if (value.playerState != PlayerState.unknown) {
                        return _section();
                      }
                      return Center(child: CupertinoActivityIndicator(),);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Widget _videosCart(int listNum, double width) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: videosByChannel[listNum].videoId)),
        )
      },
      child: videoCard(videosByChannel[listNum], width),
    );
  }

  Widget _section() {
    if (videos == null) {
      return Expanded(child: CupertinoActivityIndicator());
    } else {
      return ListView.builder(
        itemCount: videosByChannel.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                space,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: VideoDataSection(videosResponse: videos,),
                ),
                divline,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ChannelDataSection(videosResponse: videos,),
                ),
                divline,
                PlayerButtonBar(videosResponse: videos, nextVideo: videosByChannel[0].videoId,),
                divline,
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('채널의 다른 영상', style: TextStyle(fontSize: 18),),
                ),
                space,
              ],
            );
          } else {
            return _videosCart(index - 1, MediaQuery.of(context).size.width);
          }
        },
      );
    }
  }

}
