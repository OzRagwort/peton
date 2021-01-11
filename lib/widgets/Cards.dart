import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/enums/TextSize.dart';
import 'package:peton/function/channelSubscriberCountCheck.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/widgets/FavoriteIconBuilder.dart';
import 'package:peton/widgets/Line.dart';
import 'package:peton/widgets/TextForm.dart';
import 'package:extended_image/extended_image.dart';

Widget _getCard(VideosResponse videosResponse, double width, String imageQuality) {
  return ExtendedImage.network(
    'https://i.ytimg.com/vi/' + videosResponse.videoId + '/' + imageQuality,
    width: width,
    fit: BoxFit.fitWidth,
    cache: true,
    filterQuality: FilterQuality.high,
    loadStateChanged: (ExtendedImageState state) {
      switch (state.extendedImageLoadState) {
        case LoadState.loading:
          return Card(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    width: width,
                    height: width * 9 / 16,
                    child: CupertinoActivityIndicator(radius: 15,),
                  ),
                  homepageCardMetadata(videosResponse, width),
                ],
              ),
            ),
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
                  ),
                  homepageCardMetadata(videosResponse, width),
                ],
              ),
            ),
          );
          break;
        case LoadState.failed:
          if (imageQuality != 'mqdefault.jpg') {
            return _getCard(videosResponse, width, 'mqdefault.jpg');
          } else {
            print('image load error in videoCard');
          }
      }
      return null;
    },
  );
}

Widget videoCard(VideosResponse videosResponse, double width) {
  return _getCard(videosResponse, width, 'maxresdefault.jpg');
}

Widget videoCardSmall(VideosResponse videosResponse, double width) =>
    ExtendedImage.network(
      'https://i.ytimg.com/vi/'+videosResponse.videoId+'/mqdefault.jpg',
      width: width,
      fit: BoxFit.fitWidth,
      cache: true,
      filterQuality: FilterQuality.high,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return SizedBox(
              width: width,
              height: width*3/16,
              child: CupertinoActivityIndicator(radius: 10,),
            );
            break;
          case LoadState.completed:
            return Card(
              child: Container(
                child: Row(
                  children: [
                    ExtendedRawImage(
                      /// mqdefault
                      image: state.extendedImageInfo?.image,
                      width: width / 3,
                      fit: BoxFit.fitWidth,
                    ),
                    Expanded(
                      child: smallCardMetadata(videosResponse, width),
                    ),
                  ],
                ),
              ),
            );
            break;
          case LoadState.failed:
            return SizedBox(
              width: width,
              height: width*3/16,
              child: Text('error'),
            );
            break;
        }
        return null;
      },
    );

Widget channelCardSmall(Channels channels, double width) {

  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        CircleAvatar(
          radius: width / 10,
          backgroundImage:
          NetworkImage(channels.channelThumbnail),
          backgroundColor: Colors.transparent,
        ),
        verticalDivline,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(channels.channelName, style: TextStyle(fontSize: TextSize.channelNameSize),),
              Text(ChannelSubscriberCountCheck(channels.subscribers)),
            ],
          ),
        ),
        FavoriteIconBuilder(channels: channels),
      ],
    ),
  );

}

