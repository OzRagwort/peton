
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:peton/model/VideosResponse.dart';

MyShare myShare = new MyShare();

class MyShare {

  Future<Uri> shareVideo(VideosResponse videosResponse) async {
    try {
      Uri dynamicLink = await _getDynamicLinkVideo(videosResponse.videoId);
      return dynamicLink;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<Uri> _getDynamicLinkVideo(String videoId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://peton.page.link',
      link: Uri.parse('https://peton.page.link/video?id=${videoId}'),
      androidParameters: AndroidParameters(
        packageName: 'com.ozragwort.peton',
        minimumVersion: 1,
      ),
    );

    Uri dynamicUrl = await parameters.buildUrl();
    return dynamicUrl;
  }

}
