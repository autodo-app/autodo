import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import '../../../../integ_test_keys.dart';
import '../../../../redux/redux.dart';
import '../../../../theme.dart';
import '../../../../units/units.dart';
import '../../../../util.dart';
import 'base.dart';
import 'wizard.dart';
import 'wizard_info.dart';

const int cardAppearDuration = 200; // in ms

class _OilInterval extends StatelessWidget {
  const _OilInterval(this.node, this.nextNode);

  final FocusNode node, nextNode;

  @override
  Widget build(BuildContext context) => StoreBuilder(
        builder: (BuildContext context, Store<AppState> store) {
          final distance = store.state.unitsState.distance;
          final intl = store.state.intlState.intl;
          final wizard = Wizard.of<NewUserScreenWizard>(context);

          return TextFormField(
            key: IntegrationTestKeys.setOilInterval,
            maxLines: 1,
            autofocus: false,
            keyboardType: TextInputType.number,
            initialValue: distance.format(
              wizard.oilRepeatInterval,
              textField: true,
            ),
            decoration: defaultInputDecoration(
              context,
              intl.get(IntlKeys.oilChangeInterval),
              unit: distance.unitString(intl, short: true),
            ),
            validator: (v) => formValidator<int>(
              context,
              v,
              min: distance.internalToUnit(Limits.minTodoMileage),
              max: distance.internalToUnit(Limits.maxTodoMileage),
              required: true,
            ),
            onSaved: (value) => wizard.oilRepeatInterval = value == ''
                ? null
                : distance.unitToInternal(double.parse(value)),
            focusNode: node,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => changeFocus(node, nextNode),
          );
        },
      );
}

class _TireRotationInterval extends StatelessWidget {
  const _TireRotationInterval(this.node);

  final FocusNode node;

  @override
  Widget build(BuildContext context) => StoreBuilder(
        builder: (BuildContext context, Store<AppState> store) {
          final distance = store.state.unitsState.distance;
          final intl = store.state.intlState.intl;
          final wizard = Wizard.of<NewUserScreenWizard>(context);

          return TextFormField(
            key: IntegrationTestKeys.setTireRotationInterval,
            maxLines: 1,
            autofocus: false,
            keyboardType: TextInputType.number,
            initialValue: distance.format(wizard.tireRotationRepeatInterval,
                textField: true),
            decoration: defaultInputDecoration(
              context,
              intl.get(IntlKeys.tireRotationInterval),
              unit: distance.unitString(intl, short: true),
            ), // Todo: Translate
            validator: (v) => formValidator<int>(
              context,
              v,
              min: distance.internalToUnit(Limits.minTodoMileage),
              max: distance.internalToUnit(Limits.maxTodoMileage),
              required: true,
            ),
            onSaved: (value) => wizard.tireRotationRepeatInterval = value == ''
                ? null
                : distance.unitToInternal(double.parse(value)),
            focusNode: node,
            textInputAction: TextInputAction.done,
          );
        },
      );
}

class _HeaderText extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
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
              JsonIntl.of(context).get(IntlKeys.wizardRepeats),
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
          ],
        )),
      );
}

class _Card extends StatelessWidget {
  const _Card(this.oilNode, this.tireRotationNode, this.onNext);

  // final Todo oilTodo, tireRotationTodo;

  final FocusNode oilNode, tireRotationNode;

  final Function onNext;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: _OilInterval(oilNode, tireRotationNode),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: _TireRotationInterval(tireRotationNode),
            ),
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
                    key: IntegrationTestKeys.setRepeatsNext,
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      JsonIntl.of(context).get(IntlKeys.next),
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () async => await onNext(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class SetRepeatsScreen extends StatefulWidget {
  const SetRepeatsScreen();

  @override
  SetRepeatsScreenState createState() => SetRepeatsScreenState();
}

class SetRepeatsScreenState extends State<SetRepeatsScreen> {
  SetRepeatsScreenState();

  final repeatKey = GlobalKey<FormState>();

  final _oilNode = FocusNode();
  final _tiresNode = FocusNode();

  @override
  void dispose() {
    _oilNode.dispose();
    _tiresNode.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (repeatKey.currentState.validate()) {
      repeatKey.currentState.save();
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(Duration(milliseconds: 400));
      Wizard.of<NewUserScreenWizard>(context).next();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: repeatKey,
      child: AccountSetupScreen(
          header: _HeaderText(), panel: _Card(_oilNode, _tiresNode, _next)),
    );
  }
}
