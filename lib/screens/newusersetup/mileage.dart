import 'package:autodo/blocs/cars.dart';
import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/items/items.dart';

import './accountsetuptemplate.dart';

class CarEntryField extends StatefulWidget {
  final Car car;
  CarEntryField(this.car);

  @override
  State<CarEntryField> createState() => CarEntryFieldState(car);
}

class CarEntryFieldState extends State<CarEntryField> {
  Car car;
  bool firstWritten = false;

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
          if (firstWritten)
            CarsBLoC().push(car);
          firstWritten = !firstWritten;
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
        initialValue: '',
        onSaved: (value) {
          int mileage = int.parse(value.trim());
          print(mileage);
          car.updateMileage(mileage, DateTime.now());
          if (firstWritten)
            CarsBLoC().push(car);
          firstWritten = !firstWritten;
        },
      );
    }

    return Container( 
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
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
      ),
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
  var mileageEntry;
  List<Car> cars = [Car.empty()];

  MileageScreenState(this.mileageEntry);

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

    Widget card() {
      List<Widget> carFields = [];
      for (var car in cars) {
        carFields.add(CarEntryField(car));
      }

      return Container( 
        // height: viewportSize.maxHeight - 110,
        padding: EdgeInsets.all(10),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[  
            ...carFields,
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                children: <Widget>[
                  Row(  
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton.icon( 
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.add),
                        label: Text('Add'),
                        onPressed: () => setState(() => cars.add(Car.empty())),
                      ),
                      FlatButton.icon( 
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.delete),
                        label: Text('Remove'),
                        onPressed: () {
                          if (cars.length < 2) return;
                          setState(() => cars.removeAt(cars.length - 1));
                        },
                      ),
                    ],
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

    return Form(
      key: widget.mileageKey,
      child: AccountSetupScreen(header: headerText, panel: card())
    );
  }
}