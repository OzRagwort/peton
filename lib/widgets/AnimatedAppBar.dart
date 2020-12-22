
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html
/// 참고해서 개선해나갈 예정

class AnimatedAppBar extends StatefulWidget {
  AnimatedAppBar({
    Key key,
    @required this.scrollController,
    this.child,
    this.body,
  }) : super(key: key);

  final ScrollController scrollController;
  final Widget child;
  final Widget body;

  @override
  _AnimatedAppBarState createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar> {

  ScrollController scrollController;
  bool showAppbar;
  bool isScrollingDown;
  double scrollOffset;

  void scrollControllerAddListener() {
    scrollController.addListener (() {
      if ((scrollOffset - scrollController.offset).abs() > 3) {
        if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          if (!isScrollingDown) {
            isScrollingDown = true;
            showAppbar = false;
            setState(() {});
          }
        }

        if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
          if (isScrollingDown) {
            isScrollingDown = false;
            showAppbar = true;
            setState(() {});
          }
        }
      }
      scrollOffset = scrollController.offset;
    });
  }

  @override
  void initState() {
    super.initState();
    showAppbar = true;
    isScrollingDown = false;
    scrollController = widget.scrollController;
    scrollControllerAddListener();
    scrollOffset = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          height: showAppbar ? 48.0 : 0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          child: widget.child,
        ),
        widget.body,
      ],
    );
  }
}

