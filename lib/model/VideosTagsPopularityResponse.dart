
import 'package:json_annotation/json_annotation.dart';

part 'VideosTagsPopularityResponse.g.dart';

@JsonSerializable()
class VideosTagsPopularityResponse {

  final int idx;
  final int categoryId;
  final String tags;

  VideosTagsPopularityResponse({this.idx, this.categoryId, this.tags});

  factory VideosTagsPopularityResponse.fromJson(Map<String, dynamic> json) => _$VideosTagsPopularityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VideosTagsPopularityResponseToJson(this);

}
