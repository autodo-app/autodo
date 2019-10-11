import 'package:autodo/screens/newuser.dart';
import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/blocs/blocs.dart';

class LatestRepeatsScreen extends StatefulWidget {
  final GlobalKey<FormState> repeatKey;
  final Function() onNext;
  final page;

  LatestRepeatsScreen(this.repeatKey, this.onNext, this.page);

  @override 
  LatestRepeatsScreenState createState() => LatestRepeatsScreenState(page == NewUserScreenPage.LATEST);
}

class LatestRepeatsScreenState extends State<LatestRepeatsScreen> with TickerProviderStateMixin{
  bool expanded, pageTransition, pageWillBeVisible;
  AnimationController openCtrl;
  var openCurve;

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

    Widget oilMileage = TextFormField(
      maxLines: 1,
      autofocus: false,
      onTap: () => setState(() => expanded = false),
      decoration: defaultInputDecoration('(miles)', 'Last Oil Change (miles)'),
      validator: (value) => intValidator(value),
      onSaved: (value) {
        if (value != null && value != '')
          CarStatsBLoC().setLastCompleted('oil', int.parse(value.trim()));
      },
    );

    Widget tireRotationMileage = TextFormField(
      maxLines: 1,
      onTap: () => setState(() => expanded = true),
      decoration: defaultInputDecoration('(miles)', 'Last Tire Rotation (miles)'),
      validator: (value) => intValidator(value),
      onSaved: (value) {
        if (value != null && value != '')
          CarStatsBLoC().setLastCompleted('tireRotation', int.parse(value.trim()));
      },
    );

    Widget newTiresMileageField = TextFormField(
      maxLines: 1,
      onTap: () => setState(() => expanded = true),
      decoration: defaultInputDecoration('(miles)', 'Last Tire Replacement (miles)'),
      validator: (value) => intValidator(value),
      onSaved: (value) {
        if (value != null && value != '')
          CarStatsBLoC().setLastCompleted('tires', int.parse(value.trim()));
      },
    );

    // Only display the new tires field if the car is old enough to have needed new tires
    Widget newTiresMileage = 
      (CarStatsBLoC().getCurrentMileage() > RepeatingBLoC().repeatByName('tires').interval) 
      ? newTiresMileageField : Container();

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
          )
        ),
      ),
    );


    Widget card(var viewportSize) {
      return Container(
        height: openCurve.value * (viewportSize.maxHeight - 110),
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
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                    onPressed: () async {
                      setState(() => pageTransition = true);
                      await Future.delayed(Duration(milliseconds: 200)); // wait for the animation to finish
                      widget.onNext();
                    }
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
            );
          }
        ),
      ),
    );
  }
}