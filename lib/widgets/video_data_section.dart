
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:peton/widgets/text_form.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../Server.dart';
import 'line.dart';

///
class VideoDataSection extends StatelessWidget {
  VideoDataSection({this.videoName, this.viewCount, this.videoPublishedDate});

  String videoName;
  int viewCount;
  String videoPublishedDate;

  bool _subscribe = false;

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
                        child: playerTextTitle(videoName),
                      ),
                      textViewcountAndTime(viewCount, videoPublishedDate),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.library_add),
                  onPressed: null,
                ),
              ],
            ),
          ],
        );
    });
  }
}


