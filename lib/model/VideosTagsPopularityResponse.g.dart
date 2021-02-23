// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VideosTagsPopularityResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosTagsPopularityResponse _$VideosTagsPopularityResponseFromJson(
    Map<String, dynamic> json) {
  return VideosTagsPopularityResponse(
    idx: json['idx'] as int,
    categoryId: json['categoryId'] as int,
    tags: json['tags'] as String,
  );
}

Map<String, dynamic> _$VideosTagsPopularityResponseToJson(
        VideosTagsPopularityResponse instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'categoryId': instance.categoryId,
      'tags': instance.tags,
    };
