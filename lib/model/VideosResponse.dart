
import 'package:json_annotation/json_annotation.dart';
import 'package:peton/model/Channels.dart';

part 'VideosResponse.g.dart';

@JsonSerializable()
class VideosResponse {
  final int idx;
  final int categoriesIdx;
  final Channels channels;
  final String videoId;
  final String videoName;
  final String videoThumbnail;
  final String videoDescription;
  final String videoPublishedDate;
  final String videoDuration;
  final bool videoEmbeddable;
  final int viewCount;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final List<String> tags;

  VideosResponse({this.idx, this.categoriesIdx, this.channels, this.videoId, this.videoName, this.videoThumbnail, this.videoDescription, this.videoPublishedDate, this.videoDuration, this.videoEmbeddable, this.viewCount, this.likeCount, this.dislikeCount, this.commentCount, this.tags});

  factory VideosResponse.fromJson(Map<String, dynamic> json) => _$VideosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VideosResponseToJson(this);

}
