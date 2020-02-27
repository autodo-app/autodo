import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/util.dart';
import 'package:json_intl/json_intl.dart';
import 'new_user_screen_page.dart';
import 'base.dart';

class LatestRepeatsScreen extends StatefulWidget {
  final GlobalKey<FormState> repeatKey;
  final Function() onNext;
  final page;
  final todosBloc;

  LatestRepeatsScreen(
    this.repeatKey,
    this.onNext,
    this.page, {
    this.todosBloc,
  });

  @override
  LatestRepeatsScreenState createState() =>
      LatestRepeatsScreenState(page == NewUserScreenPage.LATEST, todosBloc);
}

class LatestRepeatsScreenState extends State<LatestRepeatsScreen>
    with TickerProviderStateMixin {
  bool expanded, pageTransition, pageWillBeVisible;
  AnimationController openCtrl;
  var openCurve;
  FocusNode _oilNode, _tiresNode;
  final TodosBloc todosBloc;

  LatestRepeatsScreenState(this.pageWillBeVisible, this.todosBloc);

  _next() async {
    if (widget.repeatKey.currentState.validate()) {
      widget.repeatKey.currentState.save();
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(Duration(milliseconds: 400));
      widget.onNext();
    }
  }

  @override
  void initState() {
    expanded = false;
    pageTransition = false;
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

  @override
  build(context) {
    if (pageWillBeVisible) {
      openCtrl.forward();
      pageWillBeVisible = false;
    }

    Widget oilMileage = TextFormField(
      key: IntegrationTestKeys.latestOilChangeField,
      maxLines: 1,
      autofocus: false,
      onTap: () => setState(() => expanded = false),
      decoration: defaultInputDecoration('(miles)', 'Last Oil Change (miles)'),
      validator: (value) => intNoRequire(value),
      onSaved: (val) {
        if (val == null || val == '') return;
        BlocProvider.of<TodosBloc>(context).add(AddTodo(Todo(
            name: 'oil',
            repeatName: 'oil',
            completed: true,
            completedDate: DateTime.now(),
            dueMileage: int.parse(val.trim()))));
      },
      focusNode: _oilNode,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => changeFocus(_oilNode, _tiresNode),
    );

    Widget tireRotationMileage = TextFormField(
      key: IntegrationTestKeys.latestTireRotationField,
      maxLines: 1,
      onTap: () => setState(() => expanded = true),
      decoration:
          defaultInputDecoration('(miles)', 'Last Tire Rotation (miles)'),
      validator: (value) => intNoRequire(value),
      onSaved: (val) {
        if (val == null || val == '') return;
        BlocProvider.of<TodosBloc>(context).add(AddTodo(Todo(
            name: 'tireRotation',
            repeatName: 'tireRotation',
            completed: true,
            completedDate: DateTime.now(),
            dueMileage: int.parse(val.trim()))));
      },
      focusNode: _tiresNode,
      textInputAction: TextInputAction.done,
    );

    Widget headerText = AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: (expanded) ? 0 : 110,
      child: Padding(
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
              'When was the last time you did these tasks?',
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        )),
      ),
    );

    Widget card() {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: oilMileage,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: tireRotationMileage,
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
                    key: IntegrationTestKeys.latestNextButton,
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
        key: widget.repeatKey,
        child: AccountSetupScreen(header: headerText, panel: card()));
  }
}
