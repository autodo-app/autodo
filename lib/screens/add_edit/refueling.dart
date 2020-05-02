import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_intl/json_intl.dart';

import '../../generated/localization.dart';
import '../../models/models.dart';
import '../../units/units.dart';
import '../../util.dart';
import 'forms/barrel.dart';

typedef _OnSaveCallback = Function(
  double mileage,
  DateTime date,
  double amount,
  double cost,
  String car,
);

class _MileageForm extends StatelessWidget {
  const _MileageForm({
    Key key,
    this.refueling,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  final Refueling refueling;

  final Function(String) onSaved;

  final FocusNode node, nextNode;

  @override
  Widget build(BuildContext context) {
    final distance = Distance.of(context);

    return TextFormField(
      decoration: InputDecoration(
        hintText: JsonIntl.of(context).get(IntlKeys.requiredLiteral),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        labelText:
            // Todo: Improve this translation
            '${JsonIntl.of(context).get(IntlKeys.odomReading)} (${distance.unitString(context, short: true)})',
        contentPadding:
            EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
      ),
      autofocus: true,
      initialValue: distance.format(refueling?.mileage, textField: true),
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      validator: intValidator,
      onSaved: onSaved,
      textInputAction: TextInputAction.next,
      focusNode: node,
      onFieldSubmitted: (_) => changeFocus(node, nextNode),
    );
  }
}

class _AmountForm extends StatelessWidget {
  const _AmountForm({
    Key key,
    this.refueling,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  final Refueling refueling;

  final Function(String) onSaved;

  final FocusNode node, nextNode;

  @override
  Widget build(BuildContext context) {
    final volume = Volume.of(context);

    return TextFormField(
      decoration: InputDecoration(
        hintText: JsonIntl.of(context).get(IntlKeys.requiredLiteral),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        labelText:
            // Todo: Improve this translation
            '${JsonIntl.of(context).get(IntlKeys.refuelingAmount)} (${volume.unitString(context, short: true)})',
        contentPadding:
            EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
      ),
      autofocus: true,
      initialValue: volume.format(refueling?.amount, textField: true),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: doubleValidator,
      onSaved: onSaved,
      textInputAction: TextInputAction.next,
      focusNode: node,
      onFieldSubmitted: (_) => changeFocus(node, nextNode),
    );
  }
}

class _CostForm extends StatelessWidget {
  const _CostForm({
    Key key,
    this.refueling,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  final Refueling refueling;

  final Function(String) onSaved;

  final FocusNode node, nextNode;

  @override
  Widget build(BuildContext context) {
    final currency = Currency.of(context);

    return TextFormField(
      decoration: InputDecoration(
        hintText: JsonIntl.of(context).get(IntlKeys.requiredLiteral),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        labelText:
            // Todo: Improve this translation
            '${JsonIntl.of(context).get(IntlKeys.totalPrice)} (${currency.unitString(context, short: true)})',
        contentPadding:
            EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
      ),
      autofocus: true,
      initialValue: currency.format(refueling?.cost, textField: true),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: doubleValidator,
      onSaved: onSaved,
      textInputAction: TextInputAction.next,
      focusNode: node,
      onFieldSubmitted: (_) => changeFocus(node, nextNode),
    );
  }
}

class _DateForm extends StatefulWidget {
  const _DateForm({
    Key key,
    this.refueling,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  final Refueling refueling;

  final Function(String) onSaved;

  final FocusNode node, nextNode;

  @override
  _DateFormState createState() =>
      _DateFormState(node: node, nextNode: nextNode, initial: refueling?.date);
}

class _DateFormState extends State<_DateForm> {
  _DateFormState({this.node, this.nextNode, this.initial});

  TextEditingController _ctrl;

  DateTime initial;

  FocusNode node, nextNode;

  @override
  void initState() {
    _ctrl = TextEditingController();
    if (initial != null) {
      _ctrl.text = DateFormat.yMd().format(initial);
    } else {
      _ctrl.text = DateFormat.yMd().format(DateTime.now());
    }
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
    return d != null && d.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) => Row(children: <Widget>[
        IconButton(
          icon: Icon(Icons.calendar_today),
          tooltip: JsonIntl.of(context).get(IntlKeys.chooseDate),
          onPressed: () => chooseDate(context, _ctrl.text),
        ),
        Expanded(
          child: TextFormField(
              decoration: InputDecoration(
                hintText: JsonIntl.of(context).get(IntlKeys.optional),
                labelText: JsonIntl.of(context).get(IntlKeys.refuelingDate),
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
      ]);
}

class RefuelingAddEditScreen extends StatefulWidget {
  const RefuelingAddEditScreen({
    Key key = const ValueKey('__add_edit_refueling__'),
    @required this.onSave,
    @required this.isEditing,
    @required this.cars,
    this.refueling,
  }) : super(key: key);

  final bool isEditing;
  final _OnSaveCallback onSave;

  final Refueling refueling;

  final List<Car> cars;

  @override
  _RefuelingAddEditScreenState createState() => _RefuelingAddEditScreenState();
}

class _RefuelingAddEditScreenState extends State<RefuelingAddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _mileage;
  DateTime _date;
  double _amount, _cost;
  String _car;

  FocusNode _mileageNode, _carNode, _dateNode, _amountNode, _costNode;

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    _mileageNode = FocusNode();
    _carNode = FocusNode();
    _dateNode = FocusNode();
    _amountNode = FocusNode();
    _costNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _mileageNode.dispose();
    _carNode.dispose();
    _dateNode.dispose();
    _amountNode.dispose();
    _costNode.dispose();
    super.dispose();
  }

  List<bool> _carsToInitialState() => (widget.cars
          .map((c) => c.name)
          .contains(widget.refueling?.carName))
      ? widget.cars
          .map<bool>((c) => c.name == widget.refueling?.carName)
          .toList()
      : List.generate(widget.cars.length, (idx) => (idx == 0) ? true : false);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing
                ? JsonIntl.of(context).get(IntlKeys.editRefueling)
                : JsonIntl.of(context).get(IntlKeys.addRefueling),
          ),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.all(15),
                child: ListView(
                  children: <Widget>[
                    if (widget.cars.length > 1 && widget.cars.length < 4)
                      CarToggleForm(
                        _carsToInitialState(),
                        widget.cars,
                        (List<bool> isSelected) => _car =
                            widget.cars[isSelected.indexWhere((i) => i)].name,
                      ),
                    if (widget.cars.length >= 4)
                      CarForm(
                          key: ValueKey('__refueling_car_form__'),
                          initialValue: widget.refueling?.carName,
                          onSaved: (val) => _car = val,
                          node: _carNode,
                          nextNode: _amountNode),
                    if (widget.cars.length > 1)
                      Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
                    _MileageForm(
                        refueling: widget.refueling,
                        onSaved: (val) => _mileage = double.parse(val),
                        node: _mileageNode,
                        nextNode: _carNode),
                    Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
                    _AmountForm(
                        refueling: widget.refueling,
                        onSaved: (val) => _amount = double.parse(val),
                        node: _amountNode,
                        nextNode: _costNode),
                    Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
                    _CostForm(
                        refueling: widget.refueling,
                        onSaved: (val) => _cost = double.parse(val),
                        node: _costNode,
                        nextNode: _dateNode),
                    Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
                    _DateForm(
                        refueling: widget.refueling,
                        onSaved: (val) =>
                            _date = DateFormat.yMd().parseStrict(val),
                        node: _dateNode,
                        nextNode: null),
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          tooltip: isEditing
              ? JsonIntl.of(context).get(IntlKeys.saveChanges)
              : JsonIntl.of(context).get(IntlKeys.addRefueling),
          child: Icon(isEditing ? Icons.check : Icons.add),
          onPressed: widget.cars.isEmpty
              ? null
              : () {
                  if (_formKey.currentState.validate()) {
                    // Check to see if the mileage/date combo is valid for this
                    // car

                    _formKey.currentState.save();

                    _car ??= widget.cars.first.name;
                    widget.onSave(_mileage, _date, _amount, _cost, _car);
                    Navigator.pop(context);
                  }
                },
        ),
      );
}
