import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/blocs/blocs.dart';

class LatestRepeatsScreen extends StatefulWidget {
  final GlobalKey<FormState> repeatKey;
  final Function() onNext;

  LatestRepeatsScreen(this.repeatKey, this.onNext);

  @override 
  LatestRepeatsScreenState createState() => LatestRepeatsScreenState();
}

class LatestRepeatsScreenState extends State<LatestRepeatsScreen> {
  @override 
  Widget build(BuildContext context) {
    Widget oilMileage = TextFormField(
      maxLines: 1,
      autofocus: true,
      decoration: defaultInputDecoration('(miles)', 'Last Oil Change (miles)'),
      validator: (value) =>  null,
      onSaved: (value) => CarStatsBLoC().setCurrentMileage(int.parse(value.trim())),
    );

    Widget tireRotationMileage = TextFormField(
      maxLines: 1,
      autofocus: false,
      decoration: defaultInputDecoration('(miles)', 'Last Tire Rotation (miles)'),
      validator: (value) =>  null,
      onSaved: (value) => CarStatsBLoC().setCurrentMileage(int.parse(value.trim())),
    );

    Widget newTiresMileageField = TextFormField(
      maxLines: 1,
      autofocus: false,
      decoration: defaultInputDecoration('(miles)', 'Last Tire Replacement (miles)'),
      validator: (value) =>  null,
      onSaved: (value) => CarStatsBLoC().setCurrentMileage(int.parse(value.trim())),
    );

    // Only display the new tires field if the car is old enough to have needed new tires
    Widget newTiresMileage = 
      (CarStatsBLoC().getCurrentMileage() > RepeatingBLoC().repeatByName('tires').interval) 
      ? newTiresMileageField : Container();

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
              'When was the last time you did these tasks?',
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
              child: oilMileage,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: tireRotationMileage,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: newTiresMileage,
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
                    onPressed: () => widget.onNext(),
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