
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollAppBar extends StatefulWidget {

  const ScrollAppBar({
    Key key,
    this.scrollAppBarController,
  }) : super(key: key);

  final ScrollAppBarController scrollAppBarController;

  @override
  _ScrollAppBarState createState() => _ScrollAppBarState();
}

class ScrollAppBarController {
  /// hide appbar
  ScrollController scrollViewController;
  bool showAppbar = true;
  bool isScrollingDown = false;

  ScrollAppBarController() {
    this.scrollViewController = new ScrollController();

    scrollViewController.addListener (() {
      if (scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          showAppbar = false;
          // setState (() {});
        }
      }

      if (scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showAppbar = true;
          // setState (() {});
        }
      }
    });
  }

}

class _ScrollAppBarState extends State<ScrollAppBar> {

  ScrollController _scrollViewController;
  ScrollAppBarController _scrollAppBarController;

  @override
  void initState() {
    super.initState();

    _scrollAppBarController = widget.scrollAppBarController;

    // _scrollAppBarController.scrollViewController.addListener (() {
    //   if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
    //     if (!_scrollAppBarController.isScrollingDown) {
    //       _scrollAppBarController.isScrollingDown = true;
    //       _scrollAppBarController.showAppbar = false;
    //       setState (() {});
    //     }
    //   }
    //
    //   if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
    //     if (_scrollAppBarController.isScrollingDown) {
    //       _scrollAppBarController.isScrollingDown = false;
    //       _scrollAppBarController.showAppbar = true;
    //       setState (() {});
    //     }
    //   }
    // });

  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose ();
    _scrollViewController.removeListener (() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _scrollAppBarController.showAppbar ? 48.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: AppBar(
        title: Text('title'),
        actions: <Widget>[
          //add buttons here
        ],
      ),
    );
  }

}
