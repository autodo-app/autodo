import 'package:autodo/screens/newuser.dart';
import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/blocs/blocs.dart';
import './accountsetuptemplate.dart';

const int cardAppearDuration = 200; // in ms

class SetRepeatsScreen extends StatefulWidget {
  final GlobalKey<FormState> repeatKey;
  final page;

  SetRepeatsScreen(this.repeatKey, this.page);

  @override 
  SetRepeatsScreenState createState() => SetRepeatsScreenState(this.page == NewUserScreenPage.REPEATS);
}

class SetRepeatsScreenState extends State<SetRepeatsScreen> with SingleTickerProviderStateMixin{
  bool pageWillBeVisible;
  AnimationController openCtrl;
  var openCurve;

  SetRepeatsScreenState(this.pageWillBeVisible);

  @override
  void initState() {
    openCtrl = AnimationController(  
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..addListener(() => setState(() {}));
    openCurve = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: openCtrl,
      curve: Curves.easeOutCubic
    ));
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    if (pageWillBeVisible) {
      openCtrl.forward();
      pageWillBeVisible = false;
    }

    Widget oilInterval = TextFormField(
      maxLines: 1,
      autofocus: false,
      initialValue: RepeatingBLoC().repeatByName('oil').interval.toString(),
      decoration: defaultInputDecoration('(miles)', 'Oil Change Interval (miles)'),
      validator: (value) =>  null,
      onSaved: (value) => RepeatingBLoC().editByName('oil', int.parse(value.trim())),
    );

    Widget tireRotationInterval = TextFormField(
      maxLines: 1,
      autofocus: false,
      initialValue: RepeatingBLoC().repeatByName('tireRotation').interval.toString(),
      decoration: defaultInputDecoration('(miles)', 'Tire Rotation Interval (miles)'),
      validator: (value) =>  null,
      onSaved: (value) => RepeatingBLoC().editByName('tireRotation', int.parse(value.trim())),
    );

    Widget headerText = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
      height: 110,
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
              'How often do you want to do these tasks?',
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        )
      ),
    );

    Widget card() {
      return Container( 
        // height: (viewportSize.maxHeight - 110) * openCurve.value,
        padding: EdgeInsets.all(10),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[  
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: oilInterval,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: tireRotationInterval,
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
                    onPressed: () => Navigator.popAndPushNamed(context, '/load'),
                  ),
                  FlatButton( 
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      'Next',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () => Navigator.popAndPushNamed(context, '/load'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );  
    }

    return Form(
      key: widget.repeatKey,
      child: AccountSetupScreen(header: headerText, panel: card())
    );
  }
}