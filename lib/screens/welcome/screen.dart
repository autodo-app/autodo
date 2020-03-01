import 'package:autodo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'widgets/barrel.dart';
import 'package:autodo/integ_test_keys.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key key = IntegrationTestKeys.welcomeScreen, this.dotKeys})
      : super(key: key);

  final WelcomePageScroller scroller = WelcomePageScroller();

  static const BUTTON_PADDING = 8.0;

  final List<Key> dotKeys;

  @override
  Widget build(context) => Scaffold(
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
                            keys: dotKeys,
                            controller: scroller.ctrl,
                            itemCount: scroller.screenList.length,
                            onPageSelected: scroller.showPage,
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
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
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
