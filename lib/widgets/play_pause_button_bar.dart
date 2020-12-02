// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:peton/youtube_player_iframe/src/enums/playback_quality.dart';
import 'package:peton/youtube_player_iframe/youtube_player_iframe.dart';

///
class PlayPauseButtonBar extends StatelessWidget {
  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        YoutubeValueBuilder(
          builder: (context, value) {
            return IconButton(
              icon: Icon(Icons.error),
              onPressed: () {
                context.ytController.setPlaybackRate(0.5);
                print(context.ytController.value.playbackRate);
                // context.ytController.setPlaybackQuality("small");
                // print(context.ytController);
              },
            );
          },
        ),
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
        ValueListenableBuilder<bool>(
          valueListenable: _isMuted,
          builder: (context, isMuted, _) {
            return IconButton(
              icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
              onPressed: () {
                _isMuted.value = !isMuted;
                isMuted
                    ? context.ytController.unMute()
                    : context.ytController.mute();
              },
            );
          },
        ),
        YoutubeValueBuilder(
          builder: (context, value) {
            return IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                context.ytController.setPlaybackRate(1.0);
                // print(context.ytController.value.playbackRate);
                // context.ytController.setPlaybackQuality(PlaybackQuality.highres);
                // print(context.ytController.value.playbackQuality);
              },
            );
            },
        ),
      ],
    );
  }
}