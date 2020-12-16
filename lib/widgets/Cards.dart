import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/model/VideosResponse.dart';
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

/// 수정 피룡
Widget videoCardSmall(VideosResponse videosResponse, double width) =>
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

