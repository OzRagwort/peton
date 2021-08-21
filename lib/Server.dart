
import 'package:dio/dio.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/serverInfo/ServerInfo.dart';

import 'model/VideosResponse.dart';

Server server = new Server();

class Server {

  /// videoId -> VideosResponse
  /// 영상 정보 가져오기
  Future<VideosResponse> getVideo(String videoId) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v2/videos?videoId=' + videoId);

    if (response.statusCode == 200) {
      return VideosResponse.fromJson(response.data['response'][0]);
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// channelId -> Channels
  /// 채널 정보 가져오기
  Future<Channels> getChannel(String channelId) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v2/channels?channelId=' + channelId);

    if (response.statusCode == 200) {
      return Channels.fromJson(response.data['response'][0]);
    } else {
      throw Exception('Faliled to load channels data');
    }
  }

  /// param -> List<VideosResponse>
  /// 조건에 맞는 영상 정보 가져오기
  Future<List<VideosResponse>> getVideoByParam(Map<String, String> map) async {
    Response response;
    Dio dio = new Dio();

    StringBuffer sb = StringBuffer("");

    map.forEach((key, value) {
      sb.write(key + '=' + value + '&');
    });

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v2/videos?' + sb.toString());

    List<VideosResponse> getList = [];

    if (response.statusCode == 200) {
      for(int i = 0 ; i < (response.data['response'] as List<dynamic>).length ; i++) {
        getList.add(VideosResponse.fromJson(response.data['response'][i]));
      }
      return getList;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// param -> List<Channels>
  /// 조건에 맞는 채널 정보 가져오기
  Future<List<Channels>> getChannelsByParam(Map<String, String> map) async {
    Response response;
    Dio dio = new Dio();

    StringBuffer sb = StringBuffer("");

    map.forEach((key, value) {
      sb.write(key + "=" + value + "&");
    });

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v2/channels?' + sb.toString());

    List<Channels> getList = [];

    if (response.statusCode == 200) {
      for(int i = 0 ; i < (response.data['response'] as List<dynamic>).length ; i++) {
        getList.add(Channels.fromJson(response.data['response'][i]));
      }
      return getList;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// category -> List<String>
  /// 카테고리의 태그를 가져옴
  Future<List<String>> getTagsByCategory(String category, int size) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v2/categories/' + category +
        '/tags?size=' + size.toString());

    List<dynamic> res = response.data['response'];
    List<String> list = res.map((e) => e.toString()).toList();

    if (response.statusCode == 200) {
      return list;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// 채널의 태그를 가져옴
  Future<List<String>> getTagsByChannels(String channelId, int size) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v2/channels/' + channelId +
        '/tags' +
        '?size=' + size.toString()
    );

    if (response.statusCode == 200) {
      return List.castFrom(response.data['response']);
    } else {
      throw Exception('Faliled to load getData');
    }
  }

}

