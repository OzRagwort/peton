
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/widgets/CarouselWithIndicatorChannels.dart';

class KeywordsSmallChannels extends StatelessWidget {
  Future<List<Channels>> channelsResponse;
  List<Channels> channelsList = new List<Channels>();

  int subscribers = 50000;
  int category = 1;
  int page = 1;
  int count = 15;

  @override
  Widget build(BuildContext context) {
    channelsResponse = server.getChannelsBySubscribers(subscribers, false, category, true, page, count);

    return FutureBuilder(
      future: channelsResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          channelsList.addAll(snapshot.data);
          return CarouselWithIndicatorChannels(channels: channelsList);
        } else if (snapshot.hasError) {
          print(snapshot.error);
        }
        return Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}
