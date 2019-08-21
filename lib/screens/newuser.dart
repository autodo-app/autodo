import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

BoxDecoration bgGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.blue, Colors.red],
    ),
  );
}

class SkipButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 15.0, 0.0),
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final PageController controller;
  NextButton({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 30.0),
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20.0,
              ),
            ],
          ),
          onPressed: () => controller.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
        ),
      ),
    );
  }
}

Widget nextButton(PageController controller) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 30.0),
    child: FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'next',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.0),
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 20.0,
          ),
        ],
      ),
      onPressed: () => controller.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
    ),
  );
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome to auToDo!',
        style: TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class Tutorial1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'auToDo has two main focuses:\nOrganizing Maintenance ToDo Items,\nand keeping track of your car\'s refuelings.',
        style: TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
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
  static const double _kDotSize = 8.0;

  static const double _kMaxZoom = 2.0;

  static const double _kDotSpacing = 25.0;

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
    return new Padding(
        padding: EdgeInsets.only(bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: new List<Widget>.generate(itemCount, _buildDot),
        ));
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
      child: new Center(
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
      ),
    );
  }
}

class WelcomePageScroller extends StatefulWidget {
  final VoidCallback lastPageNotifier;
  final PageController controller = PageController();

  PageController get ctrl {
    return this.controller;
  }

  WelcomePageScroller({@required this.lastPageNotifier});
  @override
  WelcomePageScrollerState createState() => WelcomePageScrollerState();
}

class WelcomePageScrollerState extends State<WelcomePageScroller> {
  final List<Widget> screens = [
    Welcome(),
    Tutorial1(),
    Tutorial2(),
  ];
  Timer debounceTimer;
  var debounceDelta = const Duration(milliseconds: 400);
  var prevVal = 0;

  @override
  void initState() {
    super.initState();
    debounceTimer = Timer(debounceDelta, () {});
    VoidCallback scrollListener = () {
      if (widget.controller.page.round() == (screens.length - 1) &&
          !debounceTimer.isActive &&
          prevVal != 2) {
        widget.lastPageNotifier();
        debounceTimer = Timer(debounceDelta, () {});
        prevVal = widget.controller.page.round();
      } else if (widget.controller.page.round() == (screens.length - 2) &&
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
      children: screens,
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  WelcomePageScroller scroller;
  Widget skipButton, nextButton;

  @override
  void initState() {
    super.initState();
    scroller = WelcomePageScroller(lastPageNotifier: this.onPageChanged);
    skipButton = SkipButton();
    nextButton = NextButton(controller: scroller.ctrl);
  }

  void onPageChanged() {
    setState(() {
      // toggle the buttons here
      if (skipButton is Container) {
        skipButton = SkipButton();
        nextButton = NextButton(controller: scroller.ctrl);
      } else {
        skipButton = Container();
        nextButton = Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: bgGradient(),
          child: Stack(
            children: <Widget>[
              scroller,
              skipButton,
              nextButton,
            ],
          ),
        ),
      ),
    );
  }
}

// class WelcomePageViewState extends State<WelcomePageView> {
//   static PageController controller;
//   static bool onLastPage = false;
//   static List<Widget> screens = [
//     Welcome(),
//     Tutorial1(),
//     Tutorial2(),
//   ];
//   WelcomePageScroller scroller;

//   @override
//   void initState() {
//     VoidCallback _onLastPage = () {
//       print(controller.page);
//       if (controller.page.round() == (screens.length - 1)) {
//         onLastPage = true;
//         setState(() {});
//       } else
//         onLastPage = false;
//     };
//     scroller = WelcomePageScroller(
//         callback: _onLastPage, controller: controller, screens: screens);
//     controller = PageController(
//       initialPage: 0,
//       // viewportFraction: 0.9,
//     )..addListener(_onLastPage);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     lastPageNotifier.close();
//     super.dispose();
//   }

//   static PageView view = PageView(
//     controller: controller,
//     children: screens,
//   );

//   Widget conditionalNextButton(BuildContext context) {
//     if (!onLastPage) {
//       return Align(
//         alignment: Alignment.bottomRight,
//         child: nextButton(context, controller),
//       );
//     } else {
//       return Container();
//     }
//   }

//   Widget nextButtonAlign(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomRight,
//       child: nextButton(context, controller),
//     );
//   }

//   Widget conditionalSkipButton(BuildContext context) {
//     if (!onLastPage) {
//       return Align(
//         alignment: Alignment.topRight,
//         child: skipButton(context),
//       );
//     } else {
//       return Container();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           decoration: bgGradient(),
//           child: Stack(
//             children: <Widget>[
//               // PageView(
//               //   controller: controller,
//               //   children: screens,
//               // ),
//               scroller,
//               // if (!onLastPage)
//               //   nextButtonAlign(context),
//               // conditionalNextButton(context),
//               conditionalSkipButton(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
