
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/database/FavoriteChannelsDb.dart';
import 'package:peton/enums/MyIcons.dart';
import 'package:peton/enums/TextSize.dart';
import 'package:peton/model/Channels.dart';

class FavoriteIconBuilder extends StatefulWidget {

  const FavoriteIconBuilder({
    Key key,
    this.channels,
  }) : super(key: key);

  final Channels channels;

  @override
  _FavoriteIconBuilderState createState() => _FavoriteIconBuilderState();
}

class _FavoriteIconBuilderState extends State<FavoriteIconBuilder> {
  Channels channels;

  @override
  void initState() {
    super.initState();
    channels = widget.channels;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Channels>(
      future: FavoriteChannelsDb().getChannel(channels.channelId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return IconButton(
            iconSize: TextSize.libraryIcon,
            icon: MyIcons.favoriteOnIcon,
            color: Colors.amber,
            onPressed: () {
              FavoriteChannelsDb().deleteChannel(channels.channelId);
              setState(() {});
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.data == null) {
          return IconButton(
            iconSize: TextSize.libraryIcon,
            icon: MyIcons.favoriteOffIcon,
            onPressed: () {
              FavoriteChannelsDb().insertChannel(channels);
              setState(() {});
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
