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

class _TodoFields extends StatefulWidget {
  const _TodoFields(this.c, this.formKey, this.showName);

  final Car c;
  final GlobalKey<FormState> formKey;
  final bool showName;

  @override
  _TodoFieldsState createState() => _TodoFieldsState(c, formKey, showName);
}

class _TodoFieldsState extends State<_TodoFields> {
  _TodoFieldsState(this.c, this.formKey, this.showName);

  final Car c;
  FocusNode _oilNode, _tiresNode;
  final GlobalKey<FormState> formKey;
  final bool showName;

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

  Widget oilMileage() => TextFormField(
        key: IntegrationTestKeys.latestOilChangeField,
        maxLines: 1,
        autofocus: false,
        decoration: defaultInputDecoration('(miles)', 'Oil Change'),
        validator: intNoRequire,
        onSaved: (val) {
          if (val == null || val == '') return;
          BlocProvider.of<TodosBloc>(context).add(AddTodo(Todo(
              name: 'oil',
              repeatName: 'oil',
              carName: c.name,
              completed: true,
              completedDate: DateTime.now(),
              dueMileage: int.parse(val.trim()))));
        },
        focusNode: _oilNode,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => changeFocus(_oilNode, _tiresNode),
      );

  Widget tireRotationMileage() => TextFormField(
        key: IntegrationTestKeys.latestTireRotationField,
        maxLines: 1,
        decoration: defaultInputDecoration('(miles)', 'Tire Rotation'),
        validator: intNoRequire,
        onSaved: (val) {
          if (val == null || val == '') return;
          BlocProvider.of<TodosBloc>(context).add(AddTodo(Todo(
              name: 'tireRotation',
              repeatName: 'tireRotation',
              carName: c.name,
              completed: true,
              completedDate: DateTime.now(),
              dueMileage: int.parse(val.trim()))));
        },
        focusNode: _tiresNode,
        textInputAction: TextInputAction.done,
      );

  @override
  Widget build(context) {
    final name = showName
        ? Text(c.name, style: Theme.of(context).primaryTextTheme.headline6)
        : Container();
    final namePadding =
        showName ? Padding(padding: EdgeInsets.only(bottom: 10)) : Container();
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                name,
                namePadding,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: oilMileage(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: tireRotationMileage(),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
              ],
            )));
  }
}

class LatestRepeatsScreen extends StatefulWidget {
  const LatestRepeatsScreen(this.formKey, this.onNext, this.page);

  final GlobalKey<FormState> formKey;

  final Function() onNext;

  final NewUserScreenPage page;

  @override
  LatestRepeatsScreenState createState() =>
      LatestRepeatsScreenState(page == NewUserScreenPage.LATEST);
}

class LatestRepeatsScreenState extends State<LatestRepeatsScreen>
    with TickerProviderStateMixin {
  LatestRepeatsScreenState(this.pageWillBeVisible);

  bool pageTransition, pageWillBeVisible;

  AnimationController openCtrl;

  Animation<double> openCurve;

  FocusNode _oilNode, _tiresNode;

  List<GlobalKey<FormState>> carFormKeys = [];

  Future<void> _next() async {
    var allValidated = true;
    carFormKeys.forEach((k) {
      if (k.currentState.validate()) {
        k.currentState.save();
      } else {
        allValidated = false;
      }
    });
    if (allValidated && widget.formKey.currentState.validate()) {
      widget.formKey.currentState.save();
      // hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(Duration(milliseconds: 400));
      widget.onNext();
    }
  }

  @override
  void initState() {
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
  void dispose() {
    _oilNode.dispose();
    _tiresNode.dispose();
    super.dispose();
  }

  Widget card() {
    // we're assuming here that the cars bloc doesn't update while this screen
    // is visible, should be a safe assumption
    final carsState = BlocProvider.of<CarsBloc>(context).state;
    if (!(carsState is CarsLoaded)) {
      return Container();
    }
    final cars = (carsState as CarsLoaded).cars;
    // again relying on this set of cars to be static
    // I'm fairly confident that there is a better way to do this but idk what it is
    final carFields = [];
    for (var i in Iterable.generate(cars.length)) {
      if (carFormKeys.length - 1 < i) {
        // only insert new keys if the index is empty
        carFormKeys.add(GlobalKey<FormState>());
      }
      carFields.add(_TodoFields(cars[i], carFormKeys[i], cars.length > 1));
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
                    'Skip',
                    style: Theme.of(context).primaryTextTheme.button,
                  ),
                  onPressed: () => Navigator.popAndPushNamed(context, '/load'),
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

  @override
  Widget build(context) {
    if (pageWillBeVisible) {
      openCtrl.forward();
      pageWillBeVisible = false;
    }

    final Widget headerText = AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: 110,
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
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
          ],
        )),
      ),
    );

    return Form(
        key: widget.formKey,
        child: AccountSetupScreen(header: headerText, panel: card()));
  }
}
