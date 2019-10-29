import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/items/items.dart';

class CarEntryField extends StatefulWidget {
  final Car car;
  CarEntryField(this.car);

  @override
  State<CarEntryField> createState() => CarEntryFieldState(car);
}

class CarEntryFieldState extends State<CarEntryField> {
  Car car;
  CarEntryFieldState(this.car);
  
  @override 
  Widget build(BuildContext context) {
    Widget nameField() {
      return TextFormField(
        maxLines: 1,
        autofocus: true,
        decoration: defaultInputDecoration('', 'Car Name'),
        validator: (value) {
          if (value == null || value == '')
            return 'Field must not be empty';
          return null;
        },
        initialValue: car.name ?? '',
        onSaved: (value) {
          car.name = value.trim();
        },
      );
    }

    Widget mileageField() {
      return TextFormField(
        maxLines: 1,
        autofocus: true,
        decoration: defaultInputDecoration('', 'Mileage'),
        validator: (value) {
          if (value == null || value == '')
            return 'Field must not be empty';
          return null;
        },
        initialValue: car.mileage ?? '',
        onSaved: (value) {
          car.mileage = double.parse(value.trim());
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),  
            child: nameField(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),  
            child: mileageField(),
          ),
        ),
      ],
    );
  }
}

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
  List<Car> cars = [Car.empty()];

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
    Widget headerText = Container(
      height: 110,
      child: Center(
        child: Column(  
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text( 
                'Before you get started,\n let\'s get some info about your car(s).',
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
              'Tap "Add" to configure multiple cars.',
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        )
      ),
    );

    Widget card(var viewportSize) {
      List<Widget> carFields = [];
      for (var car in cars) {
        carFields.add(CarEntryField(car));
      }

      return Container( 
        height: viewportSize.maxHeight - 110,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[  
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            ),
            ...carFields,
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
                      if (widget.mileageKey.currentState.validate()) {
                        widget.mileageKey.currentState.save();
                        // hide the keyboard
                        FocusScope.of(context).requestFocus(new FocusNode());
                        await Future.delayed(Duration(milliseconds: 400));
                        widget.onNext();
                      }
                    },
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
        key: widget.mileageKey,
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