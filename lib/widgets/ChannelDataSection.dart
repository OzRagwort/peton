
import 'package:flutter/material.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/enums/TextSize.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/TextForm.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'Line.dart';

///
class ChannelDataSection extends StatelessWidget {
  ChannelDataSection({this.videosResponse});

  VideosResponse videosResponse;

  bool _subscribe = false;

  @override
  Widget build(BuildContext context) {

    return YoutubeValueBuilder(builder: (context, value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => {
                    context.ytController.pause(),
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChannelInfoPage(channel: videosResponse.channels)),
                    ),
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      channelThumbnailCircle(videosResponse.channels.channelThumbnail, TextSize.channelThumbnailSize),
                      //채널 정보
                      textChannel(videosResponse.channels.channelName, videosResponse.channels.subscribers),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_subscribe ? Icons.star : Icons.star_border),
                color: Colors.black,
                onPressed: () => _subscribe = !_subscribe,
                // onPressed: () => _subscribe = !_subscribe,
              ),
            ],
          ),
        ],
      );
    });
  }
}
