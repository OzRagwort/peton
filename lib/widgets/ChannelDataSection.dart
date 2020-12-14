
import 'package:flutter/material.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/enums/TextSize.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/FavoriteIconBuilder.dart';
import 'package:peton/widgets/TextForm.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

///
class ChannelDataSection extends StatelessWidget {
  ChannelDataSection({this.videosResponse});

  VideosResponse videosResponse;

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
                    ).then((value) => context.ytController.play()),
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
              FavoriteIconBuilder(channels: videosResponse.channels,),
            ],
          ),
        ],
      );
    });
  }
}
