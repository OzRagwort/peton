import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peton/enums/text_size.dart';
import 'package:peton/function/channelSubscriberCountCheck.dart';
import 'package:peton/function/time_function.dart';
import 'package:peton/function/ViewCountCheck.dart';
import 'package:peton/model/VideosResponse.dart';

/// homepage title
Widget textTitle(String value) {
  return Text(
    value,
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
    style: TextStyle(
      color: Colors.black,
      fontSize: TextSize.titleTextSize,
      fontFamily: 'NotoSerifKR',
      fontWeight: FontWeight.w300,
      // fontWeight: FontWeight.bold
    ),
  );
}

/// videoPlayer title
Widget playerTextTitle(String value) {
  return Text(
    value,
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
    style: TextStyle(
      color: Colors.black,
      fontSize: TextSize.playerTitleTextSize,
      fontFamily: 'NotoSerifKR',
      fontWeight: FontWeight.w400,
      // fontWeight: FontWeight.bold
    ),
  );
}

/// videoPlayer 구독자 및 업로드
Widget textViewcountAndTime(int viewCount, String videoPublishedDate) {

  return RichText(
    text: TextSpan(
        text: ViewCountCheck(viewCount) + "회 · " + UploadTimeCheck(videoPublishedDate),
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: TextSize.subTextSize,
          fontFamily: 'NotoSerifKR',
          fontWeight: FontWeight.w400,
        )
    ),
  );
}

/// homePage.listview 채널 및 업로드 시간
Widget textChannelNameAndTime(String channelName, String videoPublishedDate) {

  return RichText(
    text: TextSpan(
        text: channelName + " · " + UploadTimeCheck(videoPublishedDate),
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: TextSize.subTextSize,
          fontFamily: 'NotoSerifKR',
          fontWeight: FontWeight.w400,
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
                fontSize: TextSize.channelNameSize,
                fontFamily: 'NotoSerifKR',
                fontWeight: FontWeight.w400,
              )
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 16),
        child: RichText(
          text: TextSpan(
              text: ChannelSubscriberSountCheck(subscriber),
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: TextSize.channelSubscriberSize,
                fontFamily: 'NotoSerifKR',
                fontWeight: FontWeight.w400,
              )
          ),
        ),
      )
    ],
  );
}

/// 채널 썸네일 원형
Widget channelThumbnailCircle(String thumbnail) => Stack(
  alignment: const Alignment(1, 1),
  children: [
    CircleAvatar(
      radius: TextSize.channelThumbnailSize,
      backgroundImage:
      NetworkImage(thumbnail),
      backgroundColor: Colors.transparent,
    ),
  ],
);

/// Home.listView.Card.메타데이터
Widget homepageCardMetadata(VideosResponse videosResponse, double width)  {

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
              channelThumbnailCircle(videosResponse.channels.channelThumbnail),
              const SizedBox(width: 10),
              /// 비디오 메타데이터
              Container(
                /// 수정필요
                width: (width * (2.8/4))-30,
                // width: double.infinity,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: textTitle(videosResponse.videoName),
                    ),
                    textChannelNameAndTime(videosResponse.channels.channelName, videosResponse.videoPublishedDate),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
      IconButton(
        iconSize: TextSize.libraryIcon,
        icon: const Icon(Icons.library_add_outlined),
        onPressed: null,
      ),
    ],
  );
}
