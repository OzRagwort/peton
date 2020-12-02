
import 'dart:developer';

import 'package:dio/dio.dart';

import 'model/VideosResponse.dart';

Server server = new Server();

class Server {
  Future<VideosResponse> getReq(String url) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get('http://ec2-13-125-6-3.ap-northeast-2.compute.amazonaws.com:8080/api/moaon/v1/videos?id=' + url);

    if (response.statusCode == 200) {
      return VideosResponse.fromJson(response.data[0]);
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  Future<void> putReq(String url) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.put('http://ec2-13-125-6-3.ap-northeast-2.compute.amazonaws.com:8080/api/moaon/v1/videos/' + url);

    if (response.statusCode == 200) {
      return null;
    } else {
      log('Faliled to load getData');
      throw Exception('Faliled to load getData');
    }
  }

  Future<VideosResponse> updateAndCall(String url) async {
    await putReq(url);
    return getReq(url);
  }
}

