
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosResponse.dart';

class VideosByChannels {
  final Channels channels;
  final List<VideosResponse> listVideosResponse;

  VideosByChannels({this.channels, this.listVideosResponse});
}
