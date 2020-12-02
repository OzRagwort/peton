// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Channels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channels _$ChannelsFromJson(Map<String, dynamic> json) {
  return Channels(
    idx: json['idx'] as int,
    channelId: json['channelId'] as String,
    channelName: json['channelName'] as String,
    channelThumbnail: json['channelThumbnail'] as String,
    uploadsList: json['uploadsList'] as String,
    subscribers: json['subscribers'] as int,
  );
}

Map<String, dynamic> _$ChannelsToJson(Channels instance) => <String, dynamic>{
      'idx': instance.idx,
      'channelId': instance.channelId,
      'channelName': instance.channelName,
      'channelThumbnail': instance.channelThumbnail,
      'uploadsList': instance.uploadsList,
      'subscribers': instance.subscribers,
    };
