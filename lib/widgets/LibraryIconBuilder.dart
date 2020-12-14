
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/database/LibraryVideosDb.dart';
import 'package:peton/enums/TextSize.dart';
import 'package:peton/model/LibraryVideos.dart';
import 'package:peton/model/VideosResponse.dart';

typedef LibraryWidgetBuilder<T> = Widget Function(BuildContext context, T value, Widget child);

class LibraryListenableBuilder<T> extends StatefulWidget {

  const LibraryListenableBuilder({
    Key key,
    this.child,
    this.future,
    this.videosResponse,
  }) : super(key: key);

  final Future future;

  final VideosResponse videosResponse;

  final Widget child;

  @override
  _LibraryListenableBuilderState createState() => _LibraryListenableBuilderState();
}

class _LibraryListenableBuilderState extends State<LibraryListenableBuilder> {
  Future future;
  VideosResponse videosResponse;

  @override
  void initState() {
    super.initState();
    future = widget.future;
    videosResponse = widget.videosResponse;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LibraryVideos>(
      future: LibraryVideosDb().getLibraryVideo(videosResponse.videoId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return IconButton(
            iconSize: TextSize.libraryIcon,
            icon: const Icon(Icons.library_add_check),
            onPressed: () {
              LibraryVideosDb().deleteLibraryVideo(videosResponse.videoId);
              setState(() {});
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.data == null) {
          return IconButton(
            iconSize: TextSize.libraryIcon,
            icon: const Icon(Icons.library_add_outlined),
            onPressed: () {
              LibraryVideosDb().insertLibraryVideo(LibraryVideos.fromVideosResponse(videosResponse));
              setState(() {});
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
