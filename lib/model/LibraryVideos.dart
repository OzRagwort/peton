
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
  final bool videoEmbeddable;

  LibraryVideos({this.channelId, this.channelName, this.channelThumbnail, this.videoId, this.videoName, this.videoThumbnail, this.videoPublishedDate, this.videoEmbeddable});

  Map<String, dynamic> toMap() {
    return {
      'channelId' : channelId,
      'channelName' : channelName,
      'channelThumbnail' : channelThumbnail,
      'videoId' : videoId,
      'videoName' : videoName,
      'videoThumbnail' : videoThumbnail,
      'videoPublishedDate' : videoPublishedDate,
      'videoEmbeddable' : videoEmbeddable?1:0,
    };
  }

  VideosResponse toVideosResponse() {
    return VideosResponse(
      idx: null,
      categoriesIdx: null,
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
      videoEmbeddable: videoEmbeddable,
      viewCount: null,
      likeCount: null,
      dislikeCount: null,
      commentCount: null,
      tags: null,
    );
  }

}
