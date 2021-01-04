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

Widget videoCard(VideosResponse videosResponse, double width) =>
    ExtendedImage.network(
      'https://i.ytimg.com/vi/'+videosResponse.videoId+'/maxresdefault.jpg',
      width: width,
      fit: BoxFit.fitWidth,
      cache: true,
      filterQuality: FilterQuality.high,
      // border: Border.all(color: Colors.red, width: 1.0),
      // borderRadius: BorderRadius.all(Radius.circular(30.0)),
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return SizedBox(
              width: width,
              height: width*9/16 + 85,
              child: CupertinoActivityIndicator(radius: 15,),
            );
            break;
          case LoadState.completed:
            return Card(
              child: Container(
                child: Column(
                  children: [
                    ExtendedRawImage(
                      /// maxresdefault
                      image: state.extendedImageInfo?.image,
                      width: width,
                      fit: BoxFit.fitWidth,
                      /// hqdefault => crop
                      // width: width,
                      // height: (width*270)/480,
                      // fit: BoxFit.fitWidth,
                      // sourceRect: Rect.fromCenter(width: 480, height: 270, center: Offset(240, 180)),
                    ),
                    homepageCardMetadata(videosResponse, width),
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
                    ),
                    homepageCardMetadata(videosResponse, width),
                  ],
                ),
              ),
            );
            break;
        }
        return null;
      },
    );

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
              height: width*9/16 + 85,
              child: CupertinoActivityIndicator(radius: 15,),
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
            return Text('error');
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

