
import 'package:json_annotation/json_annotation.dart';

part 'Channels.g.dart';

@JsonSerializable()
class Channels {
  final int idx;
  final String channelId;
  final String channelName;
  final String channelThumbnail;
  final String uploadsList;
  final int subscribers;
  final String bannerExternalUrl;

  Channels({this.idx, this.channelId, this.channelName, this.channelThumbnail, this.uploadsList, this.subscribers, this.bannerExternalUrl});

  factory Channels.fromJson(Map<String, dynamic> json) => _$ChannelsFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelsToJson(this);

}