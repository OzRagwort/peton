import 'dart:developer';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/OpenYoutubeButton.dart';
import 'package:peton/widgets/Line.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/VideoDataSection.dart';
import 'widgets/ChannelDataSection.dart';
import 'widgets/PlayPauseButtonBar.dart';
import 'widgets/PlayerStateSection.dart';
import 'widgets/VolumeSlider.dart';

import 'Server.dart';

class VideoPlayerPage extends StatelessWidget {
  VideoPlayerPage({Key key, this.videoId}) : super(key: key);

  String videoId;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: MyHomePage(videoId),
      ),
    );
  }

}

/// Homepage
class MyHomePage extends StatefulWidget {
  String videoId;
  MyHomePage(this.videoId);

  @override
  _MyHomePageState createState() => _MyHomePageState(videoId);
}

///state
class _MyHomePageState extends State<MyHomePage> {
  String videoId;
  _MyHomePageState(this.videoId);

  YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
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
      // Passing controller to widgets below.
      controller: _controller,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (kIsWeb && constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  player,
                  Controls(videoId),
                  // const Expanded(child: player),
                  // const SizedBox(
                  //   width: 500,
                  //   child: SingleChildScrollView(
                  //     child: Controls(videosResponse),
                  //   ),
                  // ),
                ],
              );
            }
            return ListView(
              children: [
                player,
                YoutubeValueBuilder(
                  builder: (context, value) {
                    if (value.playerState != PlayerState.unknown) {
                      return Controls(videoId);
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

///
class Controls extends StatelessWidget {
  ///
  Controls(this.videoId);
  String videoId;

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder<VideosResponse>(
        future: server.updateAndCall(videoId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  space,
                  VideoDataSection(videosResponse: snapshot.data,),
                  divline,
                  ChannelDataSection(videosResponse: snapshot.data,),
                  divline,
                  OpenYoutubeButton(snapshot.data.videoId),
                  space,
                  PlayPauseButtonBar(),
                  space,
                  VolumeSlider(),
                  space,
                  PlayerStateSection(),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return space;
        },
      );

  }

}


