
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/model/Channels.dart';

class CarouselWithIndicatorChannels extends StatefulWidget {
  CarouselWithIndicatorChannels({
    Key key,
    this.channels
  }) : super(key: key);

  final List<Channels> channels;

  @override
  _CarouselWithIndicatorChannelsState createState() => _CarouselWithIndicatorChannelsState();
}

class _CarouselWithIndicatorChannelsState extends State<CarouselWithIndicatorChannels> {

  Future<Map<Channels, List<String>>> mapsResponse;
  Map<Channels, List<String>> maps = new Map<Channels, List<String>>();
  List<Channels> channels = new List<Channels>();

  double height = 150;

  List<Widget> channelsSliders(List<Channels> channelsList) {

    mapsResponse.then((value) {setState(() {
      maps = value;
    });});

    return channelsList.map((item) => GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChannelInfoPage(channel: item)),
        )
      },
      child: Container(
        width: MediaQuery.of(context).size.width-50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(item.channelThumbnail),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.channelName,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    maps[item] != null ? maps[item].join(", ") : "",
                    maxLines: 2,
                    // overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
            // ),
          ],
        )
      ),
    )).toList();
  }

  @override
  void initState() {
    super.initState();
    channels = widget.channels;
    mapsResponse = server.getTagsByChannelsList(channels, 15);
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: channelsSliders(channels),
      options: CarouselOptions(
        height: height,
        autoPlay: false,
        autoPlayCurve: Curves.easeOutExpo,
        autoPlayInterval: Duration(seconds: 10),
        viewportFraction: 1
      ),
    );
  }
}
