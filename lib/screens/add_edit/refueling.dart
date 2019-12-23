import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/util.dart';
import 'forms/barrel.dart';

typedef _OnSaveCallback = Function(int mileage, DateTime date, double amount, double cost, String car);

class _MileageForm extends StatelessWidget {
  final Refueling refueling;
  final Function(String) onSaved;
  final FocusNode node, nextNode;

  _MileageForm({
    Key key,
    this.refueling,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);
  
  @override 
  build(context) => TextFormField(  
    decoration: InputDecoration(
      hintText: AutodoLocalizations.requiredLiteral,
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor),
      ),
      labelText: AutodoLocalizations.odomReading + ' ' + AutodoLocalizations.distanceUnitsShort,
      contentPadding: EdgeInsets.only(
          left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
    ),
    autofocus: true,
    initialValue: refueling?.mileage.toString() ?? '',
    keyboardType: TextInputType.number,
    validator: intValidator,
    onSaved: (val) => onSaved(val),
    textInputAction: TextInputAction.next,
    focusNode: node,
    onFieldSubmitted: (_) => changeFocus(node, nextNode),
  );
}

class _AmountForm extends StatelessWidget {
  final Refueling refueling;
  final Function(String) onSaved;
  final FocusNode node, nextNode;

  _AmountForm({
    Key key,
    this.refueling,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);
  
  @override 
  build(context) => TextFormField(  
    decoration: InputDecoration(
      hintText: AutodoLocalizations.requiredLiteral,
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor),
      ),
      labelText: AutodoLocalizations.refuelingAmount + ' (' + AutodoLocalizations.fuelUnits + ')',
      contentPadding: EdgeInsets.only(
          left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
    ),
    autofocus: true,
    initialValue: refueling?.amount.toString() ?? '',
    keyboardType: TextInputType.number,
    validator: intValidator,
    onSaved: (val) => onSaved(val),
    textInputAction: TextInputAction.next,
    focusNode: node,
    onFieldSubmitted: (_) => changeFocus(node, nextNode),
  );
}

class _CostForm extends StatelessWidget {
  final Refueling refueling;
  final Function(String) onSaved;
  final FocusNode node, nextNode;

  _CostForm({
    Key key,
    this.refueling,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);
  
  @override 
  build(context) => TextFormField(  
    decoration: InputDecoration(
      hintText: AutodoLocalizations.requiredLiteral,
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor),
      ),
      labelText: AutodoLocalizations.totalPrice + ' ' + AutodoLocalizations.moneyUnitsSuffix,
      contentPadding: EdgeInsets.only(
          left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
    ),
    autofocus: true,
    initialValue: refueling?.cost.toString() ?? '',
    keyboardType: TextInputType.number,
    validator: intValidator,
    onSaved: (val) => onSaved(val),
    textInputAction: TextInputAction.next,
    focusNode: node,
    onFieldSubmitted: (_) => changeFocus(node, nextNode),
  );
}

class _DateForm extends StatefulWidget {
  final Refueling refueling;
  final Function(String) onSaved;
  final FocusNode node, nextNode;

  _DateForm({
    Key key,
    this.refueling,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  @override 
  _DateFormState createState() => _DateFormState(
    node: node, 
    nextNode: nextNode,
    initial: refueling?.date
  );
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
      var d = DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Future chooseDate(BuildContext context, String initialDateString) async {
    var now = DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
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
    var d = convertToDate(date);
    return d != null && d.isBefore(DateTime.now());
  }

  @override 
  build(context) => Row(
    children: <Widget>[
      Expanded(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: AutodoLocalizations.optional,
            labelText: AutodoLocalizations.refuelingDate,
            contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 5),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor),
            ),
          ),
          controller: _ctrl,
          keyboardType: TextInputType.datetime,
          validator: (val) =>
              isValidDate(val) ? null : AutodoLocalizations.invalidDate,
          onSaved: (val) => widget.onSaved(val),
          textInputAction: (nextNode == null) ? TextInputAction.done : TextInputAction.next,
          focusNode: node,
          onFieldSubmitted: (_) {
            if (nextNode != null)
              return changeFocus(node, nextNode);
          }
        ),
      ),
      IconButton(
        icon: Icon(Icons.calendar_today),
        tooltip: AutodoLocalizations.chooseDate,
        onPressed: (() => chooseDate(context, _ctrl.text)),
      )
    ]
  );
}

class RefuelingAddEditScreen extends StatefulWidget {
  final bool isEditing;
  final _OnSaveCallback onSave;
  final Refueling refueling;

  RefuelingAddEditScreen({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.refueling,
  }) : super(key: key);

  @override 
  _RefuelingAddEditScreenState createState() => _RefuelingAddEditScreenState();
}

class _RefuelingAddEditScreenState extends State<RefuelingAddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _mileage;
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

  @override 
  build(context) => Scaffold(  
    appBar: AppBar(  
      title: Text(
        isEditing ? AutodoLocalizations.editRefueling : AutodoLocalizations.addRefueling,
      ),
    ),
    body: Form(  
      key: _formKey,
      child: Container( 
        padding: EdgeInsets.all(15),
        child: ListView(  
          children: <Widget>[
            _MileageForm(
              refueling: widget.refueling,
              onSaved: (val) => _mileage = int.parse(val),
              node: _mileageNode,
              nextNode: _carNode
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
            CarForm(
              refueling: widget.refueling,
              onSaved: (val) => _car = val,
              node: _carNode,
              nextNode: _amountNode
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
            _AmountForm(
              refueling: widget.refueling,
              onSaved: (val) => _amount = double.parse(val),
              node: _amountNode,
              nextNode: _costNode
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
            _CostForm(
              refueling: widget.refueling,
              onSaved: (val) => _cost = double.parse(val),
              node: _costNode,
              nextNode: _dateNode
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 16)),
            _DateForm(
              refueling: widget.refueling,
              onSaved: (val) => _date = DateFormat.yMd().parseStrict(val),
              node: _dateNode,
              nextNode: null
            ),
          ],
        )
      )
    ),
    floatingActionButton: FloatingActionButton(  
      tooltip: isEditing ? AutodoLocalizations.saveChanges : AutodoLocalizations.addRefueling,
      child: Icon(isEditing ? Icons.check : Icons.add),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          widget.onSave(_mileage, _date, _amount, _cost, _car);
          Navigator.pop(context);
        }
      },
    ),
  );
}