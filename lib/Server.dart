
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:peton/serverInfo/ServerInfo.dart';

import 'model/VideosResponse.dart';

Server server = new Server();

class Server {
  Future<VideosResponse> getReq(String url) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?id=' + url);

    if (response.statusCode == 200) {
      return VideosResponse.fromJson(response.data[0]);
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  Future<List<VideosResponse>> getRandbyCategoryId(String categoryId, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos/rand?category=' + categoryId + '&count=' + count.toString());

    List<VideosResponse> getList = [];

    if (response.statusCode == 200) {
      for(int i = 0 ; i < count ; i++) {
        getList.add(VideosResponse.fromJson(response.data[i]));
      }
      return getList;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  Future<int> putReq(String url) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.put(ServerInfo.serverURL + '/api/moaon/v1/videos/' + url);

    if (response.statusCode == 200) {
      return 0;
    } else {
      log('Faliled to load getData');
      throw Exception('Faliled to load getData');
    }
  }

  Future<VideosResponse> updateAndCall(String url) async {
    await putReq(url);
    return getReq(url);
  }

  Future<List<VideosResponse>> getbyChannelIdSort(String channelId, String sort, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    count = 10;

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?channel=' + channelId +
        '&sort=' + sort +
        '&page=' + page.toString() +
        '&maxResult=' + count.toString()
    );

    List<VideosResponse> getList = [];

    if (response.statusCode == 200) {
      for(int i = 0 ; i < count ; i++) {
        getList.add(VideosResponse.fromJson(response.data[i]));
      }
      return getList;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

}

