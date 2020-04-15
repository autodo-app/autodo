import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import '../../../../integ_test_keys.dart';
import '../../../../theme.dart';
import '../../../../units/units.dart';
import '../../../../util.dart';
import 'base.dart';
import 'wizard.dart';
import 'wizard_info.dart';

class _TodoFields extends StatefulWidget {
  const _TodoFields(this.car, this.formKey, this.showName);

  final NewUserCar car;
  final GlobalKey<FormState> formKey;
  final bool showName;

  @override
  _TodoFieldsState createState() => _TodoFieldsState();
}

class _TodoFieldsState extends State<_TodoFields> {
  FocusNode _oilNode, _tiresNode;

  @override
  void initState() {
    _oilNode = FocusNode();
    _tiresNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _oilNode.dispose();
    _tiresNode.dispose();
    super.dispose();
  }

  Widget oilMileage() {
    final distance = Distance.of(context);

    return TextFormField(
      key: IntegrationTestKeys.latestOilChangeField,
      maxLines: 1,
      autofocus: false,
      decoration: defaultInputDecoration(
        context,
        JsonIntl.of(context).get(IntlKeys.oilChange),
        unit: Distance.of(context).unitString(context, short: true),
      ),
      validator: (v) =>
          formValidator<int>(context, v, min: 0, max: widget.car.mileage),
      keyboardType: TextInputType.number,
      initialValue: distance.format(widget.car.oilChange, textField: true),
      onSaved: (value) => widget.car.oilChange =
          value == '' ? null : distance.unitToInternal(double.parse(value)),
      focusNode: _oilNode,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => changeFocus(_oilNode, _tiresNode),
    );
  }

  Widget tireRotationMileage() {
    final distance = Distance.of(context);

    return TextFormField(
      key: IntegrationTestKeys.latestTireRotationField,
      maxLines: 1,
      decoration: defaultInputDecoration(
        context,
        JsonIntl.of(context).get(IntlKeys.repeatTireRotation),
        unit: Distance.of(context).unitString(context, short: true),
      ),
      validator: (v) =>
          formValidator<int>(context, v, min: 0, max: widget.car.mileage),
      keyboardType: TextInputType.number,
      initialValue: distance.format(widget.car.tireRotation, textField: true),
      onSaved: (value) => widget.car.tireRotation =
          value == '' ? null : distance.unitToInternal(double.parse(value)),
      focusNode: _tiresNode,
      textInputAction: TextInputAction.done,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.showName
        ? Text(widget.car.name,
            style: Theme.of(context).primaryTextTheme.headline6)
        : Container();
    final namePadding = widget.showName
        ? Padding(padding: EdgeInsets.only(bottom: 10))
        : Container();
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                name,
                namePadding,
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: oilMileage(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: tireRotationMileage(),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
              ],
            )));
  }
}

class LatestRepeatsScreen extends StatefulWidget {
  const LatestRepeatsScreen();

  @override
  LatestRepeatsScreenState createState() => LatestRepeatsScreenState();
}

class LatestRepeatsScreenState extends State<LatestRepeatsScreen> {
  LatestRepeatsScreenState();

  AnimationController openCtrl;

  Animation<double> openCurve;

  final _oilNode = FocusNode();
  final _tiresNode = FocusNode();

  List<GlobalKey<FormState>> carFormKeys = [];

  final formKey = GlobalKey<FormState>();

  Future<void> _next() async {
    var allValidated = true;
    carFormKeys.forEach((k) {
      if (k.currentState.validate()) {
        k.currentState.save();
      } else {
        allValidated = false;
      }
    });
    if (allValidated && formKey.currentState.validate()) {
      formKey.currentState.save();
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      // await Future.delayed(Duration(milliseconds: 400));
      Wizard.of<NewUserScreenWizard>(context).next();
    }
  }

  @override
  void dispose() {
    _oilNode.dispose();
    _tiresNode.dispose();
    super.dispose();
  }

  Widget card() {
    final cars = Wizard.of<NewUserScreenWizard>(context).cars;

    final carFields = [];
    carFormKeys.clear();
    for (final car in cars) {
      final key = GlobalKey<FormState>();
      carFormKeys.add(key);
      carFields.add(_TodoFields(car, key, cars.length > 1));
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...carFields,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  child: Text(
                    JsonIntl.of(context).get(IntlKeys.skip),
                    style: Theme.of(context).primaryTextTheme.button,
                  ),
                  onPressed: () {
                    Wizard.of<NewUserScreenWizard>(context).finish();
                  },
                ),
                FlatButton(
                  key: IntegrationTestKeys.latestNextButton,
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  child: Text(
                    JsonIntl.of(context).get(IntlKeys.next),
                    style: Theme.of(context).primaryTextTheme.button,
                  ),
                  onPressed: _next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              JsonIntl.of(context).get(IntlKeys.wizardLastCompleted),
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
          ],
        ),
      ),
    );

    return Form(
      key: formKey,
      child: AccountSetupScreen(header: headerText, panel: card()),
    );
  }
}
