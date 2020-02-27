import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/localization.dart';
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
  final FocusNode node, nextNode;
  final Repeat repeat;

  const _OilInterval(this.repeat, this.node, this.nextNode);

  @override
  build(context) => TextFormField(
        key: IntegrationTestKeys.setOilInterval,
        maxLines: 1,
        autofocus: false,
        initialValue: repeat.mileageInterval.toString(),
        decoration:
            defaultInputDecoration('(miles)', 'Oil Change Interval (miles)'),
        validator: (val) => intValidator(val),
        onSaved: (val) => BlocProvider.of<RepeatsBloc>(context).add(
            UpdateRepeat(
                repeat.copyWith(mileageInterval: int.parse(val.trim())))),
        focusNode: node,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => changeFocus(node, nextNode),
      );
}

class _TireRotationInterval extends StatelessWidget {
  final FocusNode node;
  final Repeat repeat;

  const _TireRotationInterval(this.repeat, this.node);

  @override
  build(context) => TextFormField(
        key: IntegrationTestKeys.setTireRotationInterval,
        maxLines: 1,
        autofocus: false,
        initialValue: repeat.mileageInterval.toString(),
        decoration:
            defaultInputDecoration('(miles)', 'Tire Rotation Interval (miles)'),
        validator: (val) => intValidator(val),
        onSaved: (val) => BlocProvider.of<RepeatsBloc>(context).add(
            UpdateRepeat(
                repeat.copyWith(mileageInterval: int.parse(val.trim())))),
        focusNode: node,
        textInputAction: TextInputAction.done,
      );
}

class _HeaderText extends StatelessWidget {
  @override
  build(context) => Container(
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
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        )),
      );
}

class _Card extends StatelessWidget {
  final Repeat oilRepeat, tireRotationRepeat;
  final FocusNode oilNode, tireRotationNode;
  final Function onNext;

  const _Card(this.oilRepeat, this.tireRotationRepeat, this.oilNode,
      this.tireRotationNode, this.onNext);

  @override
  build(context) => Container(
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
  final GlobalKey<FormState> repeatKey;
  final page;

  const SetRepeatsScreen(this.repeatKey, this.page);

  @override
  SetRepeatsScreenState createState() =>
      SetRepeatsScreenState(page == NewUserScreenPage.REPEATS);
}

class SetRepeatsScreenState extends State<SetRepeatsScreen>
    with SingleTickerProviderStateMixin {
  bool pageWillBeVisible;
  AnimationController openCtrl;
  var openCurve;
  FocusNode _oilNode, _tiresNode;

  SetRepeatsScreenState(this.pageWillBeVisible);

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
  dispose() {
    _oilNode.dispose();
    _tiresNode.dispose();
    super.dispose();
  }

  _next() async {
    if (widget.repeatKey.currentState.validate()) {
      widget.repeatKey.currentState.save();
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(Duration(milliseconds: 400));
      Navigator.popAndPushNamed(context, AutodoRoutes.home);
    }
  }

  @override
  build(context) {
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
