import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/units/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/util.dart';
import 'package:autodo/routes.dart';
import 'package:json_intl/json_intl.dart';
import 'new_user_screen_page.dart';
import 'base.dart';

const int cardAppearDuration = 200; // in ms

class _OilInterval extends StatelessWidget {
  const _OilInterval(this.repeat, this.node, this.nextNode);

  final FocusNode node, nextNode;

  final Repeat repeat;

  @override
  Widget build(context) {
    final distance = Distance.of(context);

    return TextFormField(
      key: IntegrationTestKeys.setOilInterval,
      maxLines: 1,
      autofocus: false,
      initialValue: distance.format(
        repeat.mileageInterval,
        textField: true,
      ),
      decoration: defaultInputDecoration('(${distance.unitString(context)})',
          'Oil Change Interval (${distance.unitString(context)})'),
      validator: intValidator,
      onSaved: (val) => BlocProvider.of<RepeatsBloc>(context).add(UpdateRepeat(
          repeat.copyWith(
              mileageInterval:
                  distance.unitToInternal(double.parse(val.trim()))))),
      focusNode: node,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => changeFocus(node, nextNode),
    );
  }
}

class _TireRotationInterval extends StatelessWidget {
  const _TireRotationInterval(this.repeat, this.node);

  final FocusNode node;

  final Repeat repeat;

  @override
  Widget build(context) {
    final distance = Distance.of(context);

    return TextFormField(
      key: IntegrationTestKeys.setTireRotationInterval,
      maxLines: 1,
      autofocus: false,
      initialValue: distance.format(repeat.mileageInterval, textField: true),
      decoration: defaultInputDecoration('(${distance.unitString(context)})',
          'Tire Rotation Interval (${distance.unitString(context)})'), // Todo: Translate
      validator: intValidator,
      onSaved: (val) => BlocProvider.of<RepeatsBloc>(context).add(UpdateRepeat(
          repeat.copyWith(
              mileageInterval:
                  distance.unitToInternal(double.parse(val.trim()))))),
      focusNode: node,
      textInputAction: TextInputAction.done,
    );
  }
}

class _HeaderText extends StatelessWidget {
  @override
  Widget build(context) => Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        height: 110,
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
              'How often do you want to do these tasks?',
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
          ],
        )),
      );
}

class _Card extends StatelessWidget {
  const _Card(this.oilRepeat, this.tireRotationRepeat, this.oilNode,
      this.tireRotationNode, this.onNext);

  final Repeat oilRepeat, tireRotationRepeat;

  final FocusNode oilNode, tireRotationNode;

  final Function onNext;

  @override
  Widget build(context) => Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: _OilInterval(oilRepeat, oilNode, tireRotationNode),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child:
                  _TireRotationInterval(tireRotationRepeat, tireRotationNode),
            ),
            Container(
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
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, '/load'),
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
  const SetRepeatsScreen(this.repeatKey, this.page);

  final GlobalKey<FormState> repeatKey;

  final NewUserScreenPage page;

  @override
  SetRepeatsScreenState createState() =>
      SetRepeatsScreenState(page == NewUserScreenPage.REPEATS);
}

class SetRepeatsScreenState extends State<SetRepeatsScreen>
    with SingleTickerProviderStateMixin {
  SetRepeatsScreenState(this.pageWillBeVisible);

  bool pageWillBeVisible;

  AnimationController openCtrl;

  Animation<double> openCurve;

  FocusNode _oilNode, _tiresNode;

  @override
  void initState() {
    openCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    )..addListener(() => setState(() {}));
    openCurve = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: openCtrl, curve: Curves.easeOutCubic));
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

  Future<void> _next() async {
    if (widget.repeatKey.currentState.validate()) {
      widget.repeatKey.currentState.save();
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(Duration(milliseconds: 400));
      await Navigator.popAndPushNamed(context, AutodoRoutes.home);
    }
  }

  @override
  Widget build(context) {
    if (pageWillBeVisible) {
      openCtrl.forward();
      pageWillBeVisible = false;
    }

    return BlocBuilder<RepeatsBloc, RepeatsState>(builder: (context, state) {
      if (!(state is RepeatsLoaded) ||
          (state as RepeatsLoaded).repeats.isEmpty) {
        return LoadingIndicator();
      }
      final oilRepeat = (state as RepeatsLoaded)
          .repeats
          .firstWhere((val) => val.name == 'oil');
      final tireRotationRepeat = (state as RepeatsLoaded)
          .repeats
          .firstWhere((val) => val.name == 'tireRotation');
      print('oil $oilRepeat tire $tireRotationRepeat');

      return Form(
          key: widget.repeatKey,
          child: AccountSetupScreen(
              header: _HeaderText(),
              panel: _Card(
                  oilRepeat, tireRotationRepeat, _oilNode, _tiresNode, _next)));
    });
  }
}
