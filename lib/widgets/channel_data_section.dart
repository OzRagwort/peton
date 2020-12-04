
import 'package:flutter/material.dart';
import 'package:peton/widgets/text_form.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'line.dart';

///
class ChannelDataSection extends StatelessWidget {
  ChannelDataSection({this.channelThumbnail, this.channelName, this.subscribers});

  String channelThumbnail;
  String channelName;
  int subscribers;

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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    channelThumbnailCircle(channelThumbnail, MediaQuery.of(context).size.width),
                    //채널 정보
                    textChannel(channelName, subscribers),
                  ],
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
