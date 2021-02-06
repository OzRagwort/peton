
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:peton/ChannelInfoPage.dart';
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

  List<Channels> channels;

  double height = 150;

  List<Widget> channelsSliders(List<Channels> channelsList) {
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
            Text(
              item.channelName,
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Row(
            //   children: [
            //     /// row 가 안되!!!!!!!!!!!!!!!!
            //     Flexible(
            //       child: Text(
            //         item.channelName,
            //         maxLines: 2,
            //         softWrap: false,
            //         overflow: TextOverflow.fade,
            //         style: TextStyle(
            //           fontSize: 20.0,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //     Text("test"),
            //   ],
            // )
          ],
        )
      ),
    )).toList();
  }

  @override
  void initState() {
    super.initState();
    channels = widget.channels;
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
