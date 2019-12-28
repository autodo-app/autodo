import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'welcome.dart';
import 'tutorial1.dart';
import 'tutorial2.dart';

class WelcomePageScroller extends StatefulWidget {
  final VoidCallback lastPageNotifier;
  final PageController controller = PageController();
  final List<Widget> screens = [
    Welcome(),
    Tutorial1(),
    Tutorial2(),
  ];

  List<Widget> get screenList {
    return this.screens;
  }

  PageController get ctrl {
    return this.controller;
  }

  void showPage(page) => this.controller.jumpToPage(page);

  WelcomePageScroller({this.lastPageNotifier});
  @override
  WelcomePageScrollerState createState() => WelcomePageScrollerState();
}

class WelcomePageScrollerState extends State<WelcomePageScroller> {
  Timer debounceTimer;
  var debounceDelta = const Duration(milliseconds: 400);
  var prevVal = 0;

  @override
  void initState() {
    super.initState();
    debounceTimer = Timer(debounceDelta, () {});
    VoidCallback scrollListener = () {
      if (widget.controller.page.round() == (widget.screens.length - 1) &&
          !debounceTimer.isActive &&
          prevVal != 2) {
        widget.lastPageNotifier();
        debounceTimer = Timer(debounceDelta, () {});
        prevVal = widget.controller.page.round();
      } else if (widget.controller.page.round() ==
              (widget.screens.length - 2) &&
          !debounceTimer.isActive &&
          prevVal == 2) {
        widget.lastPageNotifier();
        debounceTimer = Timer(debounceDelta, () {});
        prevVal = widget.controller.page.round();
      } else {
        prevVal = widget.controller.page.round();
      }
    };
    widget.controller..addListener(scrollListener);
  }

  @override
  void dispose() {
    debounceTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      children: widget.screens,
    );
  }
}
