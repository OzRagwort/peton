
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:peton/VideoplayerPage.dart';
import 'package:peton/model/VideosResponse.dart';

class CarouselWithIndicatorVideos extends StatefulWidget {
  CarouselWithIndicatorVideos({
    Key key,
    this.videos
  }) : super(key: key);

  final List<VideosResponse> videos;

  @override
  _CarouselWithIndicatorVideosState createState() => _CarouselWithIndicatorVideosState();
}

class _CarouselWithIndicatorVideosState extends State<CarouselWithIndicatorVideos> {

  List<VideosResponse> videos;

  int _current = 0;

  List<Widget> imageSliders(List<VideosResponse> videosList) {

    return videosList.map((item) => Container(
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoPlayerPage(videoId: item.videoId)),
          )
        },
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item.videoThumbnail, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        item.videoName,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    )).toList();
  }

  @override
  void initState() {
    super.initState();
    videos = widget.videos;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          CarouselSlider(
            items: imageSliders(videos),
            options: CarouselOptions(
                autoPlay: true,
                autoPlayCurve: Curves.easeOutExpo,
                autoPlayInterval: Duration(seconds: 10),
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: videos.map((url) {
              int index = videos.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ]
    );
  }
}
