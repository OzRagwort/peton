// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VideosResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosResponse _$VideosResponseFromJson(Map<String, dynamic> json) {
  return VideosResponse(
    idx: json['idx'] as int,
    categoriesIdx: json['categoriesIdx'] as int,
    channels: json['channels'] == null
        ? null
        : Channels.fromJson(json['channels'] as Map<String, dynamic>),
    videoId: json['videoId'] as String,
    videoName: json['videoName'] as String,
    videoThumbnail: json['videoThumbnail'] as String,
    videoDescription: json['videoDescription'] as String,
    videoPublishedDate: json['videoPublishedDate'] as String,
    videoDuration: json['videoDuration'] as String,
    videoEmbeddable: json['videoEmbeddable'] as bool,
    viewCount: json['viewCount'] as int,
    likeCount: json['likeCount'] as int,
    dislikeCount: json['dislikeCount'] as int,
    commentCount: json['commentCount'] as int,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$VideosResponseToJson(VideosResponse instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'categoriesIdx': instance.categoriesIdx,
      'channels': instance.channels,
      'videoId': instance.videoId,
      'videoName': instance.videoName,
      'videoThumbnail': instance.videoThumbnail,
      'videoDescription': instance.videoDescription,
      'videoPublishedDate': instance.videoPublishedDate,
      'videoDuration': instance.videoDuration,
      'videoEmbeddable': instance.videoEmbeddable,
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'commentCount': instance.commentCount,
      'tags': instance.tags,
    };
