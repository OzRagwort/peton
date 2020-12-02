
import 'package:flutter/material.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/youtube_player_iframe/youtube_player_iframe.dart';

import 'line.dart';

///
class ChannelDataSection extends StatelessWidget {
  ChannelDataSection({this.channelThumbnail, this.channelName, this.subscribers});

  String channelThumbnail;
  String channelName;
  int subscribers;

  get _space => const SizedBox(height: 10);
  get _divline => const Divider(color: Colors.grey,);

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
                    _channelThumbnailCircle(channelThumbnail),
                    //채널 정보
                    _textChannel(channelName, subscribers),
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

// 제목, 조회수/시간, 채널명 등에 대한 것 생성필요할듯
Widget _textTitle(String value) {
  return RichText(
    text: TextSpan(
        text: value,
        style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold
        )
    ),
  );
}

Widget _textViewcountAndTime() {
  // String viewcount, String time
  int c = 1000;
  String t = "time";

  return RichText(
    text: TextSpan(
        text: '$c' + "회 · " + t,
        style: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 12,
        )
    ),
  );
}

// 채널 텍스트
Widget _textChannel(String value, int subscriber) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.only(left: 16),
        child: RichText(
          text: TextSpan(
              text: value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              )
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 16),
        child: RichText(
          text: TextSpan(
              text: subscriber.toString(),
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 12,
              )
          ),
        ),
      )
    ],
  );
  // RichText(
  //   text: TextSpan(
  //       text: value,
  //       style: TextStyle(
  //           color: Colors.black,
  //           fontSize: 19,
  //           fontWeight: FontWeight.bold
  //       )
  //   ),
  // );
}

Widget _text(String title, String value) {
  return RichText(
    text: TextSpan(
      text: '$title : ',
      style: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
          text: value ?? '',
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    ),
  );
}

// 채널 썸네일 원형
Widget _channelThumbnailCircle(String thumbnail) => Stack(
  alignment: const Alignment(1, 1),
  children: [
    CircleAvatar(
      radius: 30.0,
      backgroundImage:
      NetworkImage(thumbnail),
      backgroundColor: Colors.transparent,
    ),
  ],
);
