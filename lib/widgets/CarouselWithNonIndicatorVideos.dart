
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:peton/model/VideosResponse.dart';
import 'package:peton/VideoplayerPage.dart';

class CarouselWithNonIndicatorVideos extends StatelessWidget {
  CarouselWithNonIndicatorVideos({this.videos});

  final List<VideosResponse> videos;

  List<Widget> imageSliders(BuildContext context) {
    return videos.map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: item.videoId)),
                );
              },
              child: Stack(
                children: <Widget>[
                  Image.network(item.videoThumbnail, fit: BoxFit.cover, width: 1000.0, ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(150, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        item.videoName,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        autoPlayCurve: Curves.easeOutExpo,
        autoPlayInterval: Duration(seconds: 4),
        enlargeCenterPage: true,
        aspectRatio: 2.0,
      ),
      items: imageSliders(context),
    );
  }
}