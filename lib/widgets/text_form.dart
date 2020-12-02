import 'package:flutter/material.dart';

/// videoPlayer 채목
Widget textTitle(String value) {
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

/// videoPlayer 구독자 및 업로드
Widget textViewcountAndTime(int viewCount, String videoPublishedDate) {
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
Widget channelThumbnailCircle(String thumbnail) => Stack(
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

/// Home.listView.Card.메타데이터
Widget homeCardMetadata(String thumbnail, String title, int viewCount, String publishedDate)  {

  thumbnail = 'https://i.ytimg.com/vi/5d5VeWuDxxU/mqdefault.jpg';
  title = 'videoName';
  viewCount = 1234;
  publishedDate = 'videoPublishedDate';

  return Column(
    children: <Widget>[
      Image.network(
        thumbnail,
        width: 400-32.0,
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
                  child: textTitle(title),
                ),
                textViewcountAndTime(viewCount, publishedDate),
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
}
