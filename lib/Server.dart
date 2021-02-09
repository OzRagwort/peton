
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/model/VideosTagsPopularityResponse.dart';
import 'package:peton/serverInfo/ServerInfo.dart';

import 'model/VideosResponse.dart';

Server server = new Server();

class Server {

  /// videoId -> VideosResponse
  /// 영상 정보 가져오기
  Future<VideosResponse> getVideo(String videoId) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?id=' + videoId);

    if (response.statusCode == 200) {
      return VideosResponse.fromJson(response.data[0]);
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// channelId -> Channels
  /// 채널 정보 가져오기
  Future<Channels> getChannel(String channelId) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/channels?id=' + channelId);

    if (response.statusCode == 200) {
      return Channels.fromJson(response.data[0]);
    } else {
      throw Exception('Faliled to load channels data');
    }
  }

  /// category -> List<VideosResponse>
  /// 특정 카테고리의 무작위 영상 정보 가져오기
  Future<List<VideosResponse>> getRandByCategoryId(String category, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?category=' + category +
        '&maxResults=' + count.toString() +
        '&random=true'
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

  /// videoId -> 영상 최신정보 업데이트
  Future<int> refreshVideo(String videoId) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post(ServerInfo.serverURL + '/api/moaon/v1/yt-videos', data: {"videoId":videoId});

    if (response.statusCode == 200) {
      return 0;
    } else {
      log('Faliled to load getData');
      throw Exception('Faliled to load getData');
    }
  }

  /// videoId -> 영상 최신 정보 가져오기
  Future<VideosResponse> refreshGetVideo(String videoId) async {
    await refreshVideo(videoId);
    return getVideo(videoId);
  }

  /// channelId -> List<VideosResponse>
  /// 특정 채널의 정렬된 영상 가져오기
  Future<List<VideosResponse>> getByChannelIdSort(String channelId, String sort, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?channel=' + channelId +
        '&sort=' + sort +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString()
    );

    List<VideosResponse> getList = [];

    if (response.statusCode == 200) {
      for(int i = 0 ; i < (count > (response.data as List<dynamic>).length ? (response.data as List<dynamic>).length : count) ; i++) {
        getList.add(VideosResponse.fromJson(response.data[i]));
      }
      return getList;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// keyword -> List<VideosResponse>
  /// 키워드 검색
  Future<List<VideosResponse>> getSearchVideos(String keyword, int category, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?search=' + keyword +
        '&category=' + category.toString() +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString()
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

  /// category -> List<Channels>
  /// 특정 카테고리 랜덤 채널 가져오기
  Future<List<Channels>> getRandChannels(int category, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/channels?category=' + category.toString() +
        '&random=true' +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString()
    );

    List<Channels> getList = [];

    if (response.statusCode == 200) {
      for(int i = 0 ; i < count ; i++) {
        getList.add(Channels.fromJson(response.data[i]));
      }
      return getList;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// category -> List<VideosByChannels>
  /// 지금은 중복으로 채널을 가져오기도 함(수정해야함)
  Future<Map<Channels, List<VideosResponse>>> getVideosByChannels(int category, int cPage, int cCount, String sort, int vPage, int vCount) async {

    Map map = new Map<Channels, List<VideosResponse>>();

    while (map.length < cCount) {
      List<Channels> list = await getRandChannels(category, cPage, cCount);
      for (Channels c in list) {
        List<VideosResponse> videos = await getByChannelIdSort(c.channelId, sort, vPage, vCount);
        if (videos.length >= 3) {
          map[c] = videos;
        }
        if (map.length == cCount) {
          break;
        }
      }
    }

    return map;
  }

  /// category -> List<VideosTagsPopularityResponse>
  /// 카테고리의 인기 태그를 가져옴
  /// 랜덤하게 또는 더 인기있는 순서대로 등등 어찌할지 수정해야함
  Future<List<VideosTagsPopularityResponse>> getPopularTags(int category) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/popular-tags?category=' + category.toString());

    var lists = response.data as List;
    List<VideosTagsPopularityResponse> list = lists.map((e) => VideosTagsPopularityResponse.fromJson(e)).toList();

    if (response.statusCode == 200) {
      return list;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// category -> List<VideosResponse>
  /// 특정 카테고리 영상에서 태그를 검색하여 조건에 맞는 영상을 가져옴
  /// 우선 랜덤하게 호출
  Future<List<VideosResponse>> getVideosByTags(String tags, int category, bool random, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?tags=' + tags.toString() +
        '&category=' + category.toString() +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString() +
        '&random=' + random.toString()
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

  /// 평균 Score 이상의 영상을 호출
  Future<List<VideosResponse>> getVideosByScoreAvg(int category, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?overAvg=true' +
        '&category=' + category.toString() +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString()
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

  /// 공개일 기준 필터링 영상
  Future<List<VideosResponse>> getVideosByPublishedDate(int hour, int category, String sort, bool random, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?publishedDateUnderHour=' + hour.toString() +
        '&category=' + category.toString() +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString() +
        '&sort=' + sort.toString() +
        '&random=' + random.toString()
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

  /// 구독자 기준 채널 필터링
  Future<List<Channels>> getChannelsBySubscribers(int subscribers, bool over, int category, bool random, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/channels?subscribers=' + subscribers.toString() +
        '&subscribersOver=' + over.toString() +
        '&category=' + category.toString() +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString() +
        '&random=' + random.toString()
    );

    List<Channels> getList = [];

    if (response.statusCode == 200) {
      for(int i = 0 ; i < count ; i++) {
        getList.add(Channels.fromJson(response.data[i]));
      }
      return getList;
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// 구독자 기준 채널 필터링
  Future<List<VideosResponse>> getVideosBySubscribers(int subscribers, bool over, int category, bool random, int page, int count) async {
    List<Channels> channelsList = await getChannelsBySubscribers(subscribers, over, category, random, page, count);
    Response response;
    Dio dio = new Dio();

    List<String> channelNames = new List<String>();
    channelsList.forEach((e) {
      channelNames.add(e.channelId);
    });
    String channels = channelNames.join(",");

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?channel=' + channels +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString() +
        '&random=true'
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

  /// 채널의 태그를 가져옴
  Future<List<String>> getTagsByChannels(String channelId, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/channels/' + channelId +
        '/videos-tags' +
        '?maxResults=' + count.toString()
    );

    if (response.statusCode == 200) {
      return List.castFrom(response.data);
    } else {
      throw Exception('Faliled to load getData');
    }
  }

  /// 채널들의 태그를 한번에 가져오는 함수
  Future<Map<Channels, List<String>>> getTagsByChannelsList(List<Channels> channels, int count) async {

    Map<Channels, List<String>> getMap = new Map<Channels, List<String>>();

    for(Channels c in channels) {
      getMap[c] = await getTagsByChannels(c.channelId, 10);
    }

    return getMap;
  }

  /// 비디오 by sort
  /// asc -> 오래된 순, desc -> 최근순, popular -> 조회수 순
  /// asc-score -> 점수 낮은 순, desc-score -> 점수 높은 순
  Future<List<VideosResponse>> getVideosBySort(String sort, int category, int page, int count) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(ServerInfo.serverURL + '/api/moaon/v1/videos?category=' + category.toString() +
        '&sort=' + sort +
        '&page=' + page.toString() +
        '&maxResults=' + count.toString()
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

