import 'package:autodo/localization.dart';
import 'package:autodo/units/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/util.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:json_intl/json_intl.dart';
import 'base.dart';

class CarEntryField extends StatefulWidget {
  const CarEntryField(
      this.next, this.onNameSaved, this.onMileageSaved, this.formKey);

  final Function next;

  final Function onNameSaved, onMileageSaved;

  final GlobalKey<FormState> formKey;

  @override
  State<CarEntryField> createState() =>
      CarEntryFieldState(next, onNameSaved, onMileageSaved, formKey);
}

class CarEntryFieldState extends State<CarEntryField> {
  CarEntryFieldState(
      this.nextNode, this.onNameSaved, this.onMileageSaved, this.formKey);

  bool firstWritten = false;

  FocusNode _nameNode, _mileageNode;

  Function nextNode;

  final Function onNameSaved, onMileageSaved;

  final GlobalKey<FormState> formKey;

  @override
  void initState() {
    _nameNode = FocusNode();
    _mileageNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _mileageNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextFormField nameField() => TextFormField(
          key: IntegrationTestKeys.mileageNameField,
          maxLines: 1,
          autofocus: true,
          decoration: defaultInputDecoration(
              '', JsonIntl.of(context).get(IntlKeys.carName)),
          validator: requiredValidator,
          initialValue: '',
          onSaved: onNameSaved,
          focusNode: _nameNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => changeFocus(_nameNode, _mileageNode),
        );

    TextFormField mileageField() => TextFormField(
          key: IntegrationTestKeys.mileageMileageField,
          maxLines: 1,
          autofocus: false,
          decoration: defaultInputDecoration(
              '', JsonIntl.of(context).get(IntlKeys.mileage)),
          validator: intValidator,
          initialValue: '',
          onSaved: onMileageSaved,
          focusNode: _mileageNode,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) async => await nextNode(),
        );

    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Form(
        key: formKey,
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
      ),
    );
  }
}

class MileageScreen extends StatefulWidget {
  const MileageScreen(this.mileageEntry, this.mileageKey, this.onNext);

  final String mileageEntry;

  final Key mileageKey;

  final Function() onNext;

  @override
  MileageScreenState createState() => MileageScreenState(mileageEntry);
}

class MileageScreenState extends State<MileageScreen> {
  MileageScreenState(this.mileageEntry);

  String mileageEntry;

  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>()];

  List<Car> cars = [Car()];

  Future<void> _next() async {
    var allValidated = true;
    formKeys.forEach((k) {
      if (k.currentState.validate()) {
        k.currentState.save();
      } else {
        allValidated = false;
      }
    });
    if (allValidated) {
      cars.forEach((c) {
        BlocProvider.of<CarsBloc>(context).add(AddCar(c));
      });
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(Duration(milliseconds: 400));
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget headerText = Container(
      height: 110,
      child: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              JsonIntl.of(context).get(IntlKeys.carAddTitle),
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
            JsonIntl.of(context).get(IntlKeys.tapAddCars),
            style: Theme.of(context).primaryTextTheme.bodyText2,
          ),
        ],
      )),
    );

    Widget card() {
      final distance = Distance.of(context);
      final carFields = <Widget>[];
      for (var i in Iterable.generate(cars.length)) {
        carFields
            .add(CarEntryField((i == cars.length - 1) ? _next : null, (val) {
          cars[i] = cars[i].copyWith(name: val);
        },
                (val) => cars[i] = cars[i].copyWith(
                      mileage: distance.unitToInternal(double.parse(val)),
                    ),
                formKeys[i]));
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
                        label: Text(JsonIntl.of(context).get(IntlKeys.add)),
                        onPressed: () => setState(() {
                          cars.add(Car());
                          formKeys.add(GlobalKey<FormState>());
                        }),
                      ),
                      FlatButton.icon(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.delete),
                        label: Text(JsonIntl.of(context).get(IntlKeys.remove)),
                        onPressed: () {
                          if (cars.length < 2) return;
                          setState(() => cars.removeAt(cars.length - 1));
                        },
                      ),
                    ],
                  ),
                  FlatButton(
                    key: IntegrationTestKeys.mileageNextButton,
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      JsonIntl.of(context).get(IntlKeys.next),
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
