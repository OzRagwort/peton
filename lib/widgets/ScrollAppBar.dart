
import 'package:flutter/cupertino.dart';

class ScrollAppBar {

  ScrollController scrollViewController;
  bool showAppbar;
  bool isScrollingDown;

  ScrollAppBar(ScrollController scrollViewController, bool showAppbar, bool isScrollingDown) {
    this.scrollViewController = scrollViewController;
    this.showAppbar = showAppbar;
    this.isScrollingDown = isScrollingDown;
  }

}
