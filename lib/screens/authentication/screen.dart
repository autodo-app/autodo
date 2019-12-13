import 'package:autodo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'welcome/barrel.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final WelcomePageScroller scroller =
      WelcomePageScroller(lastPageNotifier: () {});
  static const BUTTON_PADDING = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: scaffoldBackgroundGradient(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: <Widget>[
                        scroller,
                        DotsIndicator(
                          controller: scroller.ctrl,
                          itemCount: scroller.screenList.length,
                          onPageSelected: (int val) {},
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SignupButton(
                            buttonPadding: BUTTON_PADDING,
                          ),
                          TrialButton(
                            buttonPadding: BUTTON_PADDING,
                          ),
                          LoginButton(
                            buttonPadding: BUTTON_PADDING,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
