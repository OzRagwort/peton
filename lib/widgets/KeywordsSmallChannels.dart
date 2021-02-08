
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/widgets/CarouselWithIndicatorChannels.dart';

class KeywordsSmallChannels extends StatelessWidget {
  KeywordsSmallChannels({this.channelsList});

  List<Channels> channelsList;

  @override
  Widget build(BuildContext context) {
    return CarouselWithIndicatorChannels(channels: channelsList);
  }
}
