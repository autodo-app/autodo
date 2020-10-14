import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../../generated/localization.dart';
import '../../../../integ_test_keys.dart';
import '../../../../redux/redux.dart';
import '../../../../theme.dart';
import '../../../../util.dart';
import 'base.dart';
import 'wizard.dart';
import 'wizard_info.dart';

class CarEntryField extends StatefulWidget {
  const CarEntryField(this.formKey, this.car);

  final GlobalKey<FormState> formKey;

  final NewUserCar car;

  @override
  State<CarEntryField> createState() => CarEntryFieldState();
}

class _NameField extends StatelessWidget {
  const _NameField(
      {@required this.nameNode,
      @required this.mileageNode,
      @required this.car});

  final FocusNode nameNode, mileageNode;
  final NewUserCar car;

  @override
  Widget build(BuildContext context) => TextFormField(
        key: IntegrationTestKeys.mileageNameField,
        maxLines: 1,
        autofocus: true,
        decoration: defaultInputDecoration(
          context,
          JsonIntl.of(context).get(IntlKeys.carName),
        ),
        validator: (v) => formValidator<String>(context, v, required: true),
        initialValue: car.name,
        onSaved: (value) => car.name = value,
        focusNode: nameNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => changeFocus(nameNode, mileageNode),
      );
}

class _MileageField extends StatelessWidget {
  const _MileageField(
      {@required this.nameNode,
      @required this.mileageNode,
      @required this.car});

  final FocusNode nameNode, mileageNode;
  final NewUserCar car;

  @override
  Widget build(BuildContext context) => StoreBuilder(
        builder: (BuildContext context, Store<AppState> store) => TextFormField(
          key: IntegrationTestKeys.mileageMileageField,
          maxLines: 1,
          autofocus: false,
          decoration: defaultInputDecoration(
            context,
            JsonIntl.of(context).get(IntlKeys.mileage),
            unit: store.state.unitsState.distance
                .unitString(store.state.intlState.intl, short: true),
          ),
          validator: (v) =>
              formValidator<int>(context, v, min: 0, required: true),
          keyboardType: TextInputType.number,
          initialValue: store.state.unitsState.distance
              .format(car.mileage, textField: true),
          onSaved: (value) => car.mileage = store.state.unitsState.distance
              .unitToInternal(double.parse(value)),
          focusNode: mileageNode,
          textInputAction: TextInputAction.done,
        ),
      );
}

class CarEntryFieldState extends State<CarEntryField> {
  CarEntryFieldState();

  bool firstWritten = false;

  FocusNode _nameNode, _mileageNode;

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
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: _NameField(
                  car: widget.car,
                  nameNode: _nameNode,
                  mileageNode: _mileageNode,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: _MileageField(
                  car: widget.car,
                  nameNode: _nameNode,
                  mileageNode: _mileageNode,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
            ],
          ),
        ),
      );
}

class MileageScreen extends StatefulWidget {
  const MileageScreen();

  @override
  MileageScreenState createState() => MileageScreenState();
}

class MileageScreenState extends State<MileageScreen> {
  MileageScreenState();

  // String mileageEntry;

  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>()];

  bool _save({bool exceptLast = false}) {
    var allValidated = true;
    for (final k in formKeys) {
      if (exceptLast && k == formKeys.last) {
        break;
      }
      if (k.currentState.validate()) {
        k.currentState.save();
      } else {
        allValidated = false;
      }
    }
    return allValidated;
  }

  Future<void> _next() async {
    final allValidated = _save();

    if (allValidated) {
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      Wizard.of<NewUserScreenWizard>(context).next();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget headerText = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
      final carFields = <Widget>[];
      final state = Wizard.of<NewUserScreenWizard>(context);
      formKeys.clear();

      for (final car in state.cars) {
        final formKey = GlobalKey<FormState>();
        formKeys.add(formKey);
        carFields.add(CarEntryField(formKey, car));
      }

      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ...carFields,
            Row(
              children: <Widget>[
                FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.add),
                  label: Text(JsonIntl.of(context).get(IntlKeys.add)),
                  onPressed: () {
                    if (_save()) {
                      setState(() {
                        state.cars.add(NewUserCar());
                        formKeys.add(GlobalKey<FormState>());
                      });
                    }
                  },
                ),
                if (state.cars.length > 1)
                  FlatButton.icon(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.delete),
                    label: Text(JsonIntl.of(context).get(IntlKeys.remove)),
                    onPressed: () {
                      if (_save(exceptLast: true)) {
                        setState(() {
                          state.cars.removeAt(state.cars.length - 1);
                        });
                      }
                    },
                  ),
                Expanded(child: SizedBox()),
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
          ],
        ),
      );
    }

    return Form(
      child: AccountSetupScreen(
        header: headerText,
        panel: card(),
      ),
    );
  }
}
