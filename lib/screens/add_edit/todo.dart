import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:json_intl/json_intl.dart';
import 'forms/barrel.dart';
import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/util.dart';

typedef _OnSaveCallback = Function(String name, DateTime dueDate,
    int dueMileage, String repeatName, String carName);

class _NameForm extends StatelessWidget {
  final Todo todo;
  final FocusNode node, nextNode;
  final Function(String) onSaved;

  const _NameForm({this.todo, this.onSaved, this.node, this.nextNode});

  @override
  build(context) => TextFormField(
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
        style: Theme.of(context).primaryTextTheme.subtitle,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        validator: requiredValidator,
        onSaved: onSaved,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => changeFocus(node, nextNode),
      );
}

class _DateForm extends StatefulWidget {
  final Todo todo;
  final Function(String) onSaved;
  final FocusNode node, nextNode;

  const _DateForm({
    Key key,
    this.todo,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  @override
  _DateFormState createState() =>
      _DateFormState(node: node, nextNode: nextNode, initial: todo?.dueDate);
}

class _DateFormState extends State<_DateForm> {
  TextEditingController _ctrl;
  DateTime initial;
  FocusNode node, nextNode;

  _DateFormState({this.node, this.nextNode, this.initial});

  @override
  initState() {
    _ctrl = TextEditingController();
    if (initial != null) _ctrl.text = DateFormat.yMd().format(initial);
    super.initState();
  }

  @override
  dispose() {
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
  build(context) => Row(children: <Widget>[
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
  final Todo todo;
  final FocusNode node, nextNode;
  final Function(String) onSaved;

  const _MileageForm({this.todo, this.onSaved, this.node, this.nextNode});

  @override
  build(context) => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          labelText: JsonIntl.of(context).get(IntlKeys.dueMileage),
          contentPadding:
              EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
        ),
        initialValue: todo?.dueMileage?.toString() ?? '',
        autofocus: false,
        focusNode: node,
        style: Theme.of(context).primaryTextTheme.subtitle,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        validator: requiredValidator,
        onSaved: onSaved,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => changeFocus(node, nextNode),
      );
}

class _CarToggleForm extends StatefulWidget {
  final List<bool> initialState;
  final List<Car> cars;
  final Function onSaved;

  const _CarToggleForm(this.initialState, this.cars, this.onSaved);

  @override
  _CarToggleFormState createState() =>
      _CarToggleFormState(initialState, cars, onSaved);
}

class _CarToggleFormState extends State<_CarToggleForm> {
  List<bool> isSelected;
  final List<Car> cars;
  final Function onSaved;

  _CarToggleFormState(this.isSelected, this.cars, this.onSaved);

  @override
  build(context) => FormField(
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
  final bool isEditing;
  final _OnSaveCallback onSave;
  final Todo todo;

  TodoAddEditScreen({
    Key key = IntegrationTestKeys.addEditTodo,
    @required this.onSave,
    @required this.isEditing,
    this.todo,
  }) : super(key: key) {
    print(todo);
  }

  @override
  _TodoAddEditScreenState createState() => _TodoAddEditScreenState();
}

class _TodoAddEditScreenState extends State<TodoAddEditScreen> {
  FocusNode _nameNode, _dateNode, _mileageNode, _repeatNode, _carNode;
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollCtrl;
  DateTime _dueDate;
  int _dueMileage;
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
  build(context) => Scaffold(
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
                        onSaved: (val) => _dueMileage = int.parse(val),
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
