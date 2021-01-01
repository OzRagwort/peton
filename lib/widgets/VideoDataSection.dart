
import 'package:flutter/material.dart';
import 'package:peton/enums/TextSize.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/TextForm.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

///
class VideoDataSection extends StatelessWidget {
  VideoDataSection({this.videosResponse});

  VideosResponse videosResponse;

  @override
  Widget build(BuildContext context) {
    return
      YoutubeValueBuilder(builder: (context, value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: textTitle(videosResponse.videoName, TextSize.playerTitleTextSize),
                      ),
                      textViewcountAndTime(videosResponse.viewCount, videosResponse.videoPublishedDate),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
    });
  }
}


