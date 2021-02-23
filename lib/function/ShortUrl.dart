
import 'package:dio/dio.dart';
import 'package:peton/serverInfo/ShortenUrlApiInfo.dart';

ShortUrl shortUrl = new ShortUrl();

class ShortUrl {

  Future<String> getShortUrl(Uri url) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.get(
      "https://openapi.naver.com/v1/util/shorturl",
      queryParameters: {"url" : url.origin + '?' + url.query},
      options: Options(
          headers: {
            "X-Naver-Client-Id" : ShortenUrlApiInfo.clientId,
            "X-Naver-Client-Secret" : ShortenUrlApiInfo.ClientSecret
          }
      ),
    );

    if (response.statusCode == 200) {
      return response.data["result"]["url"];
    } else {
      throw Exception('Faliled to load');
    }
  }

}
