import 'dart:developer';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/CheckNetwork.dart';
import 'package:peton/widgets/Line.dart';
import 'package:peton/widgets/PlayerButtonBar.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/VideoDataSection.dart';
import 'widgets/ChannelDataSection.dart';
import 'widgets/PlayerStateSection.dart';
import 'widgets/VolumeSlider.dart';

import 'Server.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key key, this.videoId}) : super(key: key);

  final String videoId;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideosResponse _videosResponse;
  String videoId;

  YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    videoId = widget.videoId;

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
        strictRelatedVideos: true,
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
      log('Entered Fullscreen');
    };
    _controller.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      Future.delayed(const Duration(seconds: 1), () {
        _controller.play();
      });
      Future.delayed(const Duration(seconds: 5), () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      });
      log('Exited Fullscreen');
    };
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();

    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            title: Text(''),
          ),
        ),

        body: CheckNetwork(
          slidingUp: true,
          body: ListView(
            children: [
              player,
              YoutubeValueBuilder(
                builder: (context, value) {
                  if (value.playerState != PlayerState.unknown) {
                    return _videosResponse == null ? _getData() : _section();
                  }
                  return LinearProgressIndicator();
                },
              ),
            ],
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

  Widget _getData() {
    return
      FutureBuilder<VideosResponse>(
        future: server.updateAndCall(videoId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _videosResponse = snapshot.data;
            return _section();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return space;
        },
      );
  }

  Widget _section() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          space,
          VideoDataSection(videosResponse: _videosResponse,),
          divline,
          ChannelDataSection(videosResponse: _videosResponse,),
          divline,
          PlayerButtonBar(videosResponse: _videosResponse),
          space,
          VolumeSlider(),
          space,
          PlayerStateSection(),
        ],
      ),
    );
  }

}
