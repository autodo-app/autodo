import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:autodo/models/barrel.dart';
import 'package:autodo/widgets/barrel.dart';
import 'package:autodo/blocs/cars/barrel.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/util.dart';

typedef _OnSaveCallback = Function(String name, int mileageInterval, List<String> carNames);

class _NameForm extends StatelessWidget {
  final Repeat repeat;
  final FocusNode node, nextNode;
  final Function(String) onSaved;

  _NameForm({this.repeat, this.onSaved, this.node, this.nextNode});

  @override 
  build(context) => TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal),
      ),
      labelText: "Action Name *",
      contentPadding:
          EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
    ),
    initialValue: repeat?.name ?? '',
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

  _DateForm({
    Key key,
    this.todo,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  @override 
  _DateFormState createState() => _DateFormState(
    node: node, 
    nextNode: nextNode,
    initial: todo?.dueDate
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
            labelText: AutodoLocalizations.dueDate,
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

class _MileageForm extends StatelessWidget {
  final Repeat repeat;
  final FocusNode node, nextNode;
  final Function(String) onSaved;

  _MileageForm({this.repeat, this.onSaved, this.node, this.nextNode});

  @override 
  build(context) => TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal),
      ),
      labelText: "Due Mileage *",
      contentPadding:
          EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
    ),
    initialValue: repeat?.mileageInterval.toString() ?? '',
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

class _CarsForm extends StatefulWidget {
  final List<Car> cars;
  final Function(List<Map<String, dynamic>>) onSaved;

  _CarsForm({this.cars, this.onSaved});

  @override 
  _CarsFormState createState() => _CarsFormState(cars, onSaved);
}

class _CarsFormState extends State<_CarsForm> {
  final List<Car> cars;
  final Function(List<Map<String, dynamic>>) onSaved;
  List<Map<String, dynamic>> _carStates = [];

  _CarsFormState(this.cars, this.onSaved) {
    for (var car in cars) {
      _carStates.add({'name': car.name, 'enabled': false});
    }
  }

  @override 
  build(context) => FormField<List<Map<String, dynamic>>>(
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        cars.length,
        (index) => ListTile(
          leading: Checkbox(
            value: _carStates[index]['enabled'],
            onChanged: (state) {
              _carStates[index]['enabled'] = state;
              setState(() {});
            },
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          title: Text(_carStates[index]['name'])
        )
      )
    ),
    onSaved: onSaved,
  );
}

class RepeatAddEditScreen extends StatefulWidget {
  final bool isEditing;
  final _OnSaveCallback onSave;
  final Repeat repeat;

  RepeatAddEditScreen({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.repeat,
  }) : super(key: key);

  @override
  _RepeatAddEditScreenState createState() => _RepeatAddEditScreenState(repeat);
}

class _RepeatAddEditScreenState extends State<RepeatAddEditScreen> {
  Repeat repeat;
  FocusNode _nameNode, _mileageNode;
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollCtrl;
  String _name;
  int _mileageInterval;
  List<Map<String, dynamic>> _cars;

  _RepeatAddEditScreenState(this.repeat);

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _nameNode = FocusNode();
    _mileageNode = FocusNode();
    scrollCtrl = ScrollController();
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _mileageNode.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  @override
  build(context) => Scaffold(  
    resizeToAvoidBottomPadding: false,
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
          controller: scrollCtrl,
          children: <Widget>[
            AutoScrollField(
              controller: scrollCtrl,
              child: _NameForm(  
                repeat: repeat,
                node: _nameNode,
                nextNode: _mileageNode,
                onSaved: (val) => _name = val,
              ),
              focusNode: _nameNode,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
              ),
              AutoScrollField(
                controller: scrollCtrl,
                child: _MileageForm(  
                  repeat: repeat,
                  node: _mileageNode,
                  onSaved: (val) => _mileageInterval = int.parse(val),
                ),
                focusNode: _mileageNode,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              BlocBuilder<CarsBloc, CarsState>(
                builder: (context, state) {
                  if (state is CarsLoaded) {
                    return _CarsForm(  
                      cars: state.cars,
                      onSaved: (cars) => _cars = cars,
                    );
                  }
                  return LoadingIndicator();
                },
              ),
              // so there is some padding to fill the bottom of the screen
              // when autoscrolling up
              Container(
                height: 10000,
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
          List<String> carNames = [];
          for (var car in _cars) {
            if (car['enabled']) {
              carNames.add(car['name']);
            }
          }
          widget.onSave(_name, _mileageInterval, carNames);
          Navigator.pop(context);
        }
      },
    ),
  );
}
