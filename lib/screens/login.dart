import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

LinearGradient blueGrey = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Colors.blueGrey[200], Colors.blueGrey[800]],
);
LinearGradient blue = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Colors.blue[300], Colors.blue[900]],
);
BoxDecoration bgGradient() {
  return BoxDecoration(
    gradient: LinearGradient.lerp(blueGrey, blue, 0.4),
    // gradient: LinearGradient(
    //   begin: Alignment.topCenter,
    //   end: Alignment.bottomCenter,
    //   colors: [Colors.blueGrey, Colors.blue[900]],
    // ),
  );
}

class FinishButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        child: RaisedButton(
          onPressed: () {},
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
            child: Text(
              "Let's Get Started!",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const BUTTON_PADDING = 8.0;

class SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(16.0, BUTTON_PADDING, 16.0, BUTTON_PADDING),
        child: RaisedButton(
          onPressed: () {},
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 14.0),
            child: Text(
              "SIGN UP",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(16.0, BUTTON_PADDING, 16.0, BUTTON_PADDING),
        child: RaisedButton(
          onPressed: () {},
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 14.0),
            child: Text(
              "TRY WITHOUT AN ACCOUNT",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, BUTTON_PADDING, 0.0, BUTTON_PADDING),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Already have an account?',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            FlatButton(
              onPressed: () {},
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Text(
                "LOG IN",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlutterLogo(
            size: 200.0,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            'Welcome to auToDo!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Text(
            "App's tagline should go here.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class Tutorial1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlutterLogo(
            size: 200.0,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            "Track Maintenance",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40.0, 0, 20.0, 0),
            child: Text(
              "Create todo items and recurring events that notify you on your terms.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class Tutorial2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'other tutorial junk',
        style: TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  static const double _kDotSize = 5.0;

  static const double _kMaxZoom = 1.75;

  static const double _kDotSpacing = 20.0;

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;
  // The base size of the dots
  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  // The increase in the size of the selected dot
  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The distance between the center of each dot
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: new List<Widget>.generate(itemCount, _buildDot),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Material(
        color: color,
        type: MaterialType.circle,
        child: new Container(
          width: _kDotSize * zoom,
          height: _kDotSize * zoom,
          child: new InkWell(
            onTap: () => onPageSelected(index),
          ),
        ),
      ),
    );
  }
}

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

  WelcomePageScroller({@required this.lastPageNotifier});
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
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      children: widget.screens,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final WelcomePageScroller scroller =
      WelcomePageScroller(lastPageNotifier: () {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: bgGradient(),
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
                          SignupButton(),
                          TrialButton(),
                          LoginButton(),
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
