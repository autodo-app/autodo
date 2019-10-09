import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/blocs/blocs.dart';

class SetRepeatsScreen extends StatefulWidget {
  final GlobalKey<FormState> repeatKey;

  SetRepeatsScreen(this.repeatKey);

  @override 
  SetRepeatsScreenState createState() => SetRepeatsScreenState();
}

class SetRepeatsScreenState extends State<SetRepeatsScreen> {
  @override 
  Widget build(BuildContext context) {
    Widget oilInterval = TextFormField(
      maxLines: 1,
      autofocus: true,
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

    Widget headerText = Padding(
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
              'How often do you want to do these tasks?',
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        )
      ),
    );

    Widget card = Expanded( 
      child: Container( 
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
      ),
    );  

    return SafeArea(
      child: Form(
        key: widget.repeatKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            headerText,
            card,
          ],
        ),
      ),
    );
  }
}