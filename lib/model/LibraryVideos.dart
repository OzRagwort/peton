
import 'package:peton/model/VideosResponse.dart';

import 'Channels.dart';

class LibraryVideos {
  // final int idx;
  final String channelId;
  final String channelName;
  final String channelThumbnail;
  final String videoId;
  final String videoName;
  final String videoThumbnail;
  final String videoPublishedDate;

  LibraryVideos({this.channelId, this.channelName, this.channelThumbnail, this.videoId, this.videoName, this.videoThumbnail, this.videoPublishedDate});

  Map<String, dynamic> toMap() {
    return {
      'channelId' : channelId,
      'channelName' : channelName,
      'channelThumbnail' : channelThumbnail,
      'videoId' : videoId,
      'videoName' : videoName,
      'videoThumbnail' : videoThumbnail,
      'videoPublishedDate' : videoPublishedDate,
    };
  }

  VideosResponse toVideosResponse() {
    return VideosResponse(
      idx: null,
      channels: Channels(
        idx: null,
        channelId: channelId,
        channelName: channelName,
        channelThumbnail: channelThumbnail,
        uploadsList: null,
        subscribers: null,
      ),
      videoId: videoId,
      videoName: videoName,
      videoThumbnail: videoThumbnail,
      videoDescription: null,
      videoPublishedDate: videoPublishedDate,
      videoDuration: null,
      tags: null,
    );
  }

  factory LibraryVideos.fromVideosResponse(VideosResponse videosResponse) {
    return LibraryVideos(
      channelId: videosResponse.channels.channelId,
      channelName: videosResponse.channels.channelName,
      channelThumbnail: videosResponse.channels.channelThumbnail,
      videoId: videosResponse.videoId,
      videoName: videosResponse.videoName,
      videoThumbnail: videosResponse.videoThumbnail,
      videoPublishedDate: videosResponse.videoPublishedDate,
    );
  }

}
