import 'package:flutter/material.dart';

import 'package:autodo/util.dart';
import 'package:autodo/theme.dart';
import 'base.dart';

class CarEntryField extends StatefulWidget {
  final Function next;
  final Function onNameSaved, onMileageSaved;

  CarEntryField(this.next, this.onNameSaved, this.onMileageSaved);

  @override
  State<CarEntryField> createState() =>
      CarEntryFieldState(next, onNameSaved, onMileageSaved);
}

class CarEntryFieldState extends State<CarEntryField> {
  bool firstWritten = false;
  FocusNode _nameNode, _mileageNode;
  Function nextNode;
  final Function onNameSaved, onMileageSaved;

  CarEntryFieldState(this.nextNode, this.onNameSaved, this.onMileageSaved);

  @override
  initState() {
    _nameNode = FocusNode();
    _mileageNode = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    _nameNode.dispose();
    _mileageNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameField() => TextFormField(
          maxLines: 1,
          autofocus: true,
          decoration: defaultInputDecoration('', 'Car Name'),
          validator: (val) => requiredValidator(val),
          initialValue: '',
          onSaved: onNameSaved,
          focusNode: _nameNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => changeFocus(_nameNode, _mileageNode),
        );

    mileageField() => TextFormField(
          maxLines: 1,
          autofocus: false,
          decoration: defaultInputDecoration('', 'Mileage'),
          validator: (val) => intValidator(val),
          initialValue: '',
          onSaved: onMileageSaved,
          focusNode: _mileageNode,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) async => await nextNode(),
        );

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
  static final emptyCar = {'name': '', 'mileage': 0};
  List<Map<String, dynamic>> cars = [emptyCar];

  MileageScreenState(this.mileageEntry);

  _next() async {
    if (widget.mileageKey.currentState.validate()) {
      widget.mileageKey.currentState.save();
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(Duration(milliseconds: 400));
      widget.onNext();
    }
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
      )),
    );

    Widget card() {
      List<Widget> carFields = [];
      for (var car in cars) {
        carFields.add(CarEntryField(_next, (val) => car['name'] = val,
            (val) => car['mileage'] = int.parse(val)));
      }

      return Container(
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
                        onPressed: () => setState(() => cars.add(emptyCar)),
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
                    onPressed: () async => await _next(),
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
        child: AccountSetupScreen(header: headerText, panel: card()));
  }
}
