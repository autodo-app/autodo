import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:json_intl/json_intl.dart';

import '../../blocs/blocs.dart';
import '../../generated/localization.dart';
import '../../integ_test_keys.dart';
import '../../models/models.dart';
import '../../units/units.dart';
import '../../util.dart';
import '../../widgets/widgets.dart';
import 'forms/barrel.dart';

typedef _OnSaveCallback = Function(String name, DateTime dueDate,
    double dueMileage, String repeatName, String carName);

class _NameForm extends StatelessWidget {
  const _NameForm({this.todo, this.onSaved, this.node, this.nextNode});

  final Todo todo;

  final FocusNode node, nextNode;

  final Function(String) onSaved;

  @override
  Widget build(context) => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          labelText: JsonIntl.of(context).get(IntlKeys.actionName),
          contentPadding:
              EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
        ),
        initialValue: todo?.name ?? '',
        autofocus: true,
        focusNode: node,
        style: Theme.of(context).primaryTextTheme.subtitle2,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        validator: requiredValidator,
        onSaved: onSaved,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => changeFocus(node, nextNode),
      );
}

class _DateForm extends StatefulWidget {
  const _DateForm({
    Key key,
    this.todo,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  final Todo todo;

  final Function(String) onSaved;

  final FocusNode node, nextNode;

  @override
  _DateFormState createState() =>
      _DateFormState(node: node, nextNode: nextNode, initial: todo?.dueDate);
}

class _DateFormState extends State<_DateForm> {
  _DateFormState({this.node, this.nextNode, this.initial});

  TextEditingController _ctrl;

  DateTime initial;

  FocusNode node, nextNode;

  @override
  void initState() {
    _ctrl = TextEditingController();
    if (initial != null) _ctrl.text = DateFormat.yMd().format(initial);
    super.initState();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  DateTime convertToDate(String input) {
    try {
      final d = DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Future chooseDate(BuildContext context, String initialDateString) async {
    final now = DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now;

    final result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (result == null) return;

    setState(() {
      _ctrl.text = DateFormat.yMd().format(result);
    });
  }

  bool isValidDate(String date) {
    if (date.isEmpty) return true;
    final d = convertToDate(date);
    return d != null && d.isAfter(DateTime.now());
  }

  @override
  Widget build(context) => Row(children: <Widget>[
        Expanded(
          child: TextFormField(
              decoration: InputDecoration(
                hintText: JsonIntl.of(context).get(IntlKeys.optional),
                labelText: JsonIntl.of(context).get(IntlKeys.dueDate),
                contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 5),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              controller: _ctrl,
              keyboardType: TextInputType.datetime,
              validator: (val) => isValidDate(val)
                  ? null
                  : JsonIntl.of(context).get(IntlKeys.invalidDate),
              onSaved: (val) => widget.onSaved(val),
              textInputAction: (nextNode == null)
                  ? TextInputAction.done
                  : TextInputAction.next,
              focusNode: node,
              onFieldSubmitted: (_) {
                if (nextNode != null) return changeFocus(node, nextNode);
              }),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          tooltip: JsonIntl.of(context).get(IntlKeys.chooseDate),
          onPressed: () => chooseDate(context, _ctrl.text),
        )
      ]);
}

class _MileageForm extends StatelessWidget {
  const _MileageForm({this.todo, this.onSaved, this.node, this.nextNode});

  final Todo todo;

  final FocusNode node, nextNode;

  final Function(String) onSaved;

  @override
  Widget build(context) {
    final distance = Distance.of(context);

    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        labelText: JsonIntl.of(context).get(IntlKeys.dueMileage),
        contentPadding:
            EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
      ),
      initialValue: distance.format(todo?.dueMileage, textField: true),
      autofocus: false,
      focusNode: node,
      style: Theme.of(context).primaryTextTheme.subtitle2,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      validator: requiredValidator,
      onSaved: onSaved,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => changeFocus(node, nextNode),
    );
  }
}

class _CarToggleForm extends StatefulWidget {
  const _CarToggleForm(this.initialState, this.cars, this.onSaved);

  final List<bool> initialState;

  final List<Car> cars;

  final Function onSaved;

  @override
  _CarToggleFormState createState() =>
      _CarToggleFormState(initialState, cars, onSaved);
}

class _CarToggleFormState extends State<_CarToggleForm> {
  _CarToggleFormState(this.isSelected, this.cars, this.onSaved);

  List<bool> isSelected;

  final List<Car> cars;

  final Function onSaved;

  @override
  Widget build(context) => FormField(
        builder: (state) => Center(
          child: ToggleButtons(
            children: cars.map((c) => Text(c.name)).toList(),
            onPressed: (int index) {
              setState(() {
                for (var buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: isSelected,
            // Constraints are per the Material spec
            constraints: BoxConstraints(minWidth: 88, minHeight: 36),
            textStyle: Theme.of(context).primaryTextTheme.button,
            color: Theme.of(context)
                .primaryTextTheme
                .button
                .color
                .withOpacity(0.7),
            selectedColor: Theme.of(context).accentTextTheme.button.color,
            fillColor: Theme.of(context).primaryColor,
            borderWidth: 2.0,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onSaved: (_) => onSaved(isSelected),
        validator: (_) => null,
      );
}

class TodoAddEditScreen extends StatefulWidget {
  TodoAddEditScreen({
    Key key = IntegrationTestKeys.addEditTodo,
    @required this.onSave,
    @required this.isEditing,
    this.todo,
  }) : super(key: key) {
    print(todo);
  }

  final bool isEditing;

  final _OnSaveCallback onSave;

  final Todo todo;

  @override
  _TodoAddEditScreenState createState() => _TodoAddEditScreenState();
}

class _TodoAddEditScreenState extends State<TodoAddEditScreen> {
  FocusNode _nameNode, _dateNode, _mileageNode, _repeatNode, _carNode;
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollCtrl;
  DateTime _dueDate;
  double _dueMileage;
  String _name, _repeatName, _car;

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _nameNode = FocusNode();
    _dateNode = FocusNode();
    _mileageNode = FocusNode();
    _repeatNode = FocusNode();
    _carNode = FocusNode();
    scrollCtrl = ScrollController();
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _dateNode.dispose();
    _mileageNode.dispose();
    _repeatNode.dispose();
    _carNode.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  List<bool> _carsToInitialState(cars) =>
      (cars.map((c) => c.name).contains(widget.todo?.carName))
          ? cars.map((c) => c.name == widget.todo?.carName)
          : List.generate(cars.length, (idx) => (idx == 0) ? true : false);

  @override
  Widget build(context) => Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            isEditing
                ? JsonIntl.of(context).get(IntlKeys.editTodo)
                : JsonIntl.of(context).get(IntlKeys.addTodo),
          ),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.all(15),
                child: ListView(
                  controller: scrollCtrl,
                  children: <Widget>[
                    AutoScrollField(
                      controller: scrollCtrl,
                      child: _NameForm(
                        todo: widget.todo,
                        node: _nameNode,
                        nextNode: _dateNode,
                        onSaved: (name) => _name = name,
                      ),
                      focusNode: _nameNode,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Divider(),
                    ),
                    AutoScrollField(
                      controller: scrollCtrl,
                      child: _DateForm(
                        todo: widget.todo,
                        node: _dateNode,
                        nextNode: _mileageNode,
                        onSaved: (val) => _dueDate = (val == null || val == '')
                            ? null
                            : DateFormat.yMd().parseStrict(val),
                      ),
                      focusNode: _dateNode,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                    AutoScrollField(
                      controller: scrollCtrl,
                      child: _MileageForm(
                        todo: widget.todo,
                        node: _mileageNode,
                        nextNode: _repeatNode,
                        onSaved: (val) => _dueMileage = double.parse(val),
                      ),
                      focusNode: _mileageNode,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                    BlocBuilder<RepeatsBloc, RepeatsState>(
                      builder: (context, state) {
                        if (state is RepeatsLoaded) {
                          return AutoScrollField(
                            controller: scrollCtrl,
                            focusNode: _repeatNode,
                            position: 240,
                            child: RepeatForm(
                              todo: widget.todo,
                              node: _repeatNode,
                              onSaved: (val) => _repeatName = val,
                              requireInput: false,
                            ),
                          );
                        }
                        return LoadingIndicator();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                    BlocBuilder<CarsBloc, CarsState>(
                      builder: (context, state) {
                        if (state is CarsLoaded) {
                          if (state.cars.length <= 1) {
                            return Container();
                          } else if (state.cars.length < 4) {
                            return _CarToggleForm(
                              _carsToInitialState(state.cars),
                              state.cars,
                              (List<bool> isSelected) => _car = state
                                  .cars[isSelected.indexWhere((i) => i)].name,
                            );
                          } else {
                            return CarForm(
                                key: ValueKey('__refueling_car_form__'),
                                initialValue: widget.todo?.carName,
                                onSaved: (val) => _car = val,
                                node: _carNode,
                                nextNode: null);
                          }
                        } else {
                          return LoadingIndicator();
                        }
                      },
                    ),
                    // so there is some padding to fill the bottom of the screen
                    // when autoscrolling up
                    Container(
                      height: 10000,
                    ),
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          tooltip: isEditing
              ? JsonIntl.of(context).get(IntlKeys.saveChanges)
              : JsonIntl.of(context).get(IntlKeys.addRefueling),
          child: Icon(isEditing ? Icons.check : Icons.add),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.onSave(_name, _dueDate, _dueMileage, _repeatName, _car);
              Navigator.pop(context);
            }
          },
        ),
      );
}
