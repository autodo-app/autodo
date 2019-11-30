import 'package:autodo/screens/newuser.dart';
import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/util.dart';
import 'package:autodo/blocs/blocs.dart';
import './accountsetuptemplate.dart';

class LatestRepeatsScreen extends StatefulWidget {
  final GlobalKey<FormState> repeatKey;
  final Function() onNext;
  final page;

  LatestRepeatsScreen(this.repeatKey, this.onNext, this.page);

  @override
  LatestRepeatsScreenState createState() =>
      LatestRepeatsScreenState(page == NewUserScreenPage.LATEST);
}

class LatestRepeatsScreenState extends State<LatestRepeatsScreen>
    with TickerProviderStateMixin {
  bool expanded, pageTransition, pageWillBeVisible;
  AnimationController openCtrl;
  var openCurve;
  FocusNode _oilNode, _tiresNode;

  LatestRepeatsScreenState(this.pageWillBeVisible);

  String intValidator(String value) {
    try {
      int.parse(value);
      return null;
    } catch (e) {
      return 'Value must be an integer.';
    }
  }

  @override
  void initState() {
    expanded = false;
    pageTransition = false;
    openCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..addListener(() => setState(() {}));
    openCurve = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: openCtrl, curve: Curves.easeOutCubic));
    _oilNode = FocusNode();
    _tiresNode = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    _oilNode.dispose();
    _tiresNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (pageWillBeVisible) {
      openCtrl.forward();
      pageWillBeVisible = false;
    }

    Widget oilMileage = TextFormField(
      maxLines: 1,
      autofocus: false,
      onTap: () => setState(() => expanded = false),
      decoration: defaultInputDecoration('(miles)', 'Last Oil Change (miles)'),
      validator: (value) => intValidator(value),
      onSaved: (value) {
        if (value != null && value != '')
          RepeatingBLoC().setLastCompleted('oil', int.parse(value.trim()));
      },
      focusNode: _oilNode,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => changeFocus(_oilNode, _tiresNode),
    );

    Widget tireRotationMileage = TextFormField(
      maxLines: 1,
      onTap: () => setState(() => expanded = true),
      decoration:
          defaultInputDecoration('(miles)', 'Last Tire Rotation (miles)'),
      validator: (value) => intValidator(value),
      onSaved: (value) {
        if (value != null && value != '')
          RepeatingBLoC()
              .setLastCompleted('tireRotation', int.parse(value.trim()));
      },
      focusNode: _tiresNode,
      textInputAction: TextInputAction.done,
    );

    Widget headerText = AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: (expanded) ? 0 : 110,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Before you get started,\n let\'s get some info about your car.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(230),
                ),
              ),
            ),
            Text(
              'When was the last time you did these tasks?',
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        )),
      ),
    );

    Widget card() {
      return Container(
        // height: openCurve.value * (viewportSize.maxHeight - 110),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: oilMileage,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: tireRotationMileage,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, '/load'),
                  ),
                  FlatButton(
                      padding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      child: Text(
                        'Next',
                        style: Theme.of(context).primaryTextTheme.button,
                      ),
                      onPressed: () async {
                        setState(() => pageTransition = true);
                        await Future.delayed(Duration(
                            milliseconds:
                                200)); // wait for the animation to finish
                        widget.onNext();
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Form(
        key: widget.repeatKey,
        child: AccountSetupScreen(header: headerText, panel: card()));
  }
}
