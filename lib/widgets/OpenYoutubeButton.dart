
import 'package:flutter/material.dart';
import 'package:peton/enums/MyIcons.dart';
import 'package:peton/function/LaunchYoutube.dart';

class OpenYoutubeButton extends StatelessWidget {
  String videoId;
  OpenYoutubeButton(this.videoId);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => LaunchYoutube.openYoutube(videoId),
      child: MyIcons.youtubeIcon,
    );

  }

}