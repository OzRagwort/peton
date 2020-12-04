import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/text_form.dart';

Widget videoCard(VideosResponse videosResponse, double width) => Card(
    child: Container(
      // margin: EdgeInsets.symmetric(vertical: 8.0),
      // padding: EdgeInsets.all(1.0),
      child: Column(
        children: <Widget>[
          Image.network(
            // 'https://i.ytimg.com/vi/5d5VeWuDxxU/mqdefault.jpg',
            videosResponse.videoThumbnail,
            width: width,
            fit: BoxFit.fitWidth,
          ),
          homeCardMetadata(videosResponse.channels.channelThumbnail, videosResponse.videoName, videosResponse.viewCount, videosResponse.videoPublishedDate, width),
        ],
      ),
    ),
  );

// Widget videoCard(VideosResponse videosResponse, double width) {
//
//   Card(
//     child: Container(
//       // margin: EdgeInsets.symmetric(vertical: 8.0),
//       // padding: EdgeInsets.all(1.0),
//       child: Column(
//         children: <Widget>[
//           Image.network(
//             // 'https://i.ytimg.com/vi/5d5VeWuDxxU/mqdefault.jpg',
//             videosResponse.videoThumbnail,
//             width: width,
//             fit: BoxFit.fitWidth,
//           ),
//           homeCardMetadata(videosResponse.channels.channelThumbnail,videosResponse.videoName,videosResponse.viewCount,videosResponse.videoPublishedDate,width),
//         ],
//       ),
//     ),
//   );
//
// }
