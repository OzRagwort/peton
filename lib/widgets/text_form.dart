import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// videoPlayer 채목
Widget textTitle(String value) {
  return Text(
    value,
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
    style: TextStyle(
      color: Colors.black,
      fontSize: 17,
      // fontWeight: FontWeight.bold
    ),
  );
}

/// videoPlayer 구독자 및 업로드
Widget textViewcountAndTime(int viewCount, String videoPublishedDate) {
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

/// videoPlayer 채널 텍스트
Widget textChannel(String value, int subscriber) {
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

/// 채널 썸네일 원형
Widget channelThumbnailCircle(String thumbnail, double cThumbnailWidth) => Stack(
  alignment: const Alignment(1, 1),
  children: [
    CircleAvatar(
      radius: cThumbnailWidth,
      backgroundImage:
      NetworkImage(thumbnail),
      backgroundColor: Colors.transparent,
    ),
  ],
);

/// Home.listView.Card.메타데이터
Widget homeCardMetadata(String thumbnail, String title, int viewCount, String publishedDate, double width)  {

  // thumbnail = 'https://yt3.ggpht.com/ytc/AAUvwnhKjzZNLe8ZHiapSPVdcA1RUine4UCI7VmQRkVsuw=s240-c-k-c0x00ffffff-no-rj';
  // title = 'videoNamevideoNamevideoNamevideoNamevideoNamevideoName';
  // viewCount = 1234;
  // publishedDate = 'videoPublishedDate';

  double cThumbnailWidth = width / 16;
  double libraryWidth = width / 12;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 채널
              channelThumbnailCircle(thumbnail, cThumbnailWidth),
              const SizedBox(width: 10),
              /// 비디오 메타데이터
              Container(
                width: (width * (2.8/4))-30,
                // width: double.infinity,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: textTitle(title),
                    ),
                    textViewcountAndTime(viewCount, publishedDate),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
      IconButton(
        iconSize: libraryWidth.toDouble(),
        icon: const Icon(Icons.library_add_outlined),
        onPressed: null,
      ),
    ],
  );
}
