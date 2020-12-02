import 'dart:ui';

import 'package:flutter/material.dart';

Widget videoCard(double width) {

  return Card(
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 7.0),
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Image.network(
            'https://i.ytimg.com/vi/5d5VeWuDxxU/mqdefault.jpg',
            width: width-32.0,
            fit: BoxFit.fitWidth,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _textTitle('videoName'),
                    ),
                    _textViewcountAndTime(1234, 'videoPublishedDate'),
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
      ),
    ),
  );

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

Widget _textViewcountAndTime(int viewCount, String videoPublishedDate) {
  // String viewcount, String time
  int c = viewCount;
  String t = videoPublishedDate;

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

