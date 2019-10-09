import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/blocs/blocs.dart';

class MileageScreen extends StatefulWidget {
  final String mileageEntry;
  final mileageKey;
  final Function() onNext;

  MileageScreen(this.mileageEntry, this.mileageKey, this.onNext);

  @override 
  MileageScreenState createState() => MileageScreenState(this.mileageEntry);
}

class MileageScreenState extends State<MileageScreen> {
  FocusNode mileageNode;
  var mileageEntry;

  MileageScreenState(this.mileageEntry);

  @override 
  void initState() {
    mileageNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    mileageNode.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    Widget field = TextFormField(
      maxLines: 1,
      autofocus: true,
      decoration: defaultInputDecoration('', 'Car Mileage'),
      validator: (value) {
        if (value == null || value == '')
          return 'Field must not be empty';
        return null;
      },
      initialValue: mileageEntry,
      onSaved: (value) {
        mileageEntry = value;
        CarStatsBLoC().setCurrentMileage(int.parse(value.trim()));
      },
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
              'How many miles are currently on your car?',
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
              child: field,
            ),
            Padding( 
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
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
                    onPressed: () {
                      if (widget.mileageKey.currentState.validate()) {
                        widget.mileageKey.currentState.save();
                        widget.onNext();
                        // setState(() => page = NewUserScreenPage.REPEATS);
                        // TODO: figure out how to signal to the parent that it needs to switch states
                      }
                    },
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
        key: widget.mileageKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              headerText,
              card,
            ],
          ),
        ),
      ),
    );
  }
}