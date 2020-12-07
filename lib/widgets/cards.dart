import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/text_form.dart';
import 'package:extended_image/extended_image.dart';

Widget videoCard(VideosResponse videosResponse, double width) =>
    ExtendedImage.network(
      'https://i.ytimg.com/vi/'+videosResponse.videoId+'/hq720.jpg',
      width: width,
      fit: BoxFit.fitWidth,
      cache: true,
      filterQuality: FilterQuality.high,
      // border: Border.all(color: Colors.red, width: 1.0),
      // borderRadius: BorderRadius.all(Radius.circular(30.0)),
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Image.asset(
              "lib/assets/spinner.gif",
              fit: BoxFit.fill,
            );
            break;
          case LoadState.completed:
            return Card(
              child: Container(
                child: Column(
                  children: [
                    ExtendedRawImage(
                      image: state.extendedImageInfo?.image,
                      width: width,
                      fit: BoxFit.fitWidth,
                      filterQuality: FilterQuality.high,
                    ),
                    homepageCardMetadata(videosResponse.channels.channelThumbnail, videosResponse.videoName, videosResponse.viewCount, videosResponse.videoPublishedDate, width),
                  ],
                ),
              ),
            );
            break;
          case LoadState.failed:
            return Card(
              child: Container(
                child: Column(
                  children: [
                    Image.network(
                      'https://i.ytimg.com/vi/'+videosResponse.videoId+'/mqdefault.jpg',
                      width: width,
                      fit: BoxFit.fitWidth,
                      filterQuality: FilterQuality.high,
                    ),
                    homepageCardMetadata(videosResponse.channels.channelThumbnail, videosResponse.videoName, videosResponse.viewCount, videosResponse.videoPublishedDate, width),
                  ],
                ),
              ),
            );
            break;
        }
        return null;
      },
    );

// Widget videoCard(VideosResponse videosResponse, double width) => Card(
//   child: Container(
//     child: ExtendedImage.network(
//       videosResponse.videoThumbnail,
//       width: width,
//       fit: BoxFit.fitWidth,
//       cache: true,
//       border: Border.all(color: Colors.red, width: 1.0),
//       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//       loadStateChanged: (ExtendedImageState state) {
//         switch (state.extendedImageLoadState) {
//           case LoadState.loading:
//           // return Image.asset(
//           //   "lib/assets/spinner.gif",
//           //   fit: BoxFit.fill,
//           // );
//           // return null;
//             return Text('');
//             break;
//           case LoadState.completed:
//             return Column(
//               children: [
//                 ExtendedRawImage(
//                   image: state.extendedImageInfo?.image,
//                   width: width,
//                   fit: BoxFit.fitWidth,
//                 ),
//                 homeCardMetadata(videosResponse.channels.channelThumbnail, videosResponse.videoName, videosResponse.viewCount, videosResponse.videoPublishedDate, width),
//               ],
//             );
//             break;
//           case LoadState.failed:
//             break;
//         }
//         return null;
//       },
//     ),
//     // child: homeCardMetadata(videosResponse.channels.channelThumbnail, videosResponse.videoName, videosResponse.viewCount, videosResponse.videoPublishedDate, width),
//
//   ),
// );

