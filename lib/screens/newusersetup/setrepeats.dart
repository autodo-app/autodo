import 'package:autodo/screens/newuser.dart';
import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/blocs/blocs.dart';

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
  AnimationController _ctrl;
  Animation _val;

  SetRepeatsScreenState(this.pageWillBeVisible);

  @override
  void initState() {
    _ctrl= AnimationController(  
      vsync: this,
      duration: Duration(milliseconds: cardAppearDuration),
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    if (pageWillBeVisible) {
      _ctrl.animateTo(1.0, curve: Curves.bounceOut);
      pageWillBeVisible = false;
    }

    Widget oilInterval = TextFormField(
      maxLines: 1,
      autofocus: false,
      initialValue: RepeatingBLoC().repeatByName('oil').interval.toString(),
      decoration: defaultInputDecoration('(miles)', 'Oil Change Interval (miles)'),
      validator: (value) =>  null,
      onSaved: (value) => CarStatsBLoC().setCurrentMileage(int.parse(value.trim())),
    );

    Widget tireRotationInterval = TextFormField(
      maxLines: 1,
      autofocus: false,
      initialValue: RepeatingBLoC().repeatByName('tireRotation').interval.toString(),
      decoration: defaultInputDecoration('(miles)', 'Tire Rotation Interval (miles)'),
      validator: (value) =>  null,
      onSaved: (value) => CarStatsBLoC().setCurrentMileage(int.parse(value.trim())),
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

    Widget card(var viewportSize) {
      return AnimatedContainer( 
        duration: Duration(milliseconds: 400),
        height: (viewportSize.maxHeight - 110) * _ctrl.value,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(  
          borderRadius: BorderRadius.only(
            topRight:  Radius.circular(30),
            topLeft:  Radius.circular(30),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[  
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: oilInterval,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: tireRotationInterval,
            ),
            Padding( 
              padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
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
                    onPressed: () => Navigator.popAndPushNamed(context, '/'),
                  ),
                  FlatButton( 
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      'Next',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () => Navigator.popAndPushNamed(context, '/'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );  
    }

    return SafeArea(
      child: Form(
      key: widget.repeatKey,
      child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ), 
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  headerText,
                  card(viewportConstraints),
                ],
              ),
            ),
          ),
        );}
      ),),
    );
  }
}