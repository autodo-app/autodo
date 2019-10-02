import 'package:autodo/sharedmodels/autoscrollfield.dart';
import 'package:autodo/sharedmodels/ensurevisiblewidget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:autodo/blocs/todo.dart';
import 'package:autodo/blocs/repeating.dart';
import 'package:autodo/sharedmodels/autocompletefield.dart';
import 'package:autodo/items/items.dart';

enum TodoEditMode { CREATE, EDIT }

class CreateTodoScreen extends StatefulWidget {
  final TodoEditMode mode;
  final MaintenanceTodoItem existing;
  CreateTodoScreen({@required this.mode, this.existing});

  @override
  CreateTodoScreenState createState() => CreateTodoScreenState();
}

class CreateTodoScreenState extends State<CreateTodoScreen> {
  DateTime selectedDate = DateTime.now();
  FocusNode _nameNode, _dateNode, _mileageNode, _repeatNode;
  MaintenanceTodoItem todoItem;
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollCtrl;
  Repeat selectedRepeat;
  final _autocompleteKey = GlobalKey<AutoCompleteTextFieldState<Repeat>>();
  TextEditingController _autocompleteController;

  @override
  void initState() {
    super.initState();
    todoItem = (widget.mode == TodoEditMode.EDIT)
        ? widget.existing
        : MaintenanceTodoItem.empty();
    _nameNode = FocusNode();
    _dateNode = FocusNode();
    _mileageNode = FocusNode();
    _repeatNode = FocusNode();
    scrollCtrl = ScrollController();
    _autocompleteController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the focus nodes when the Form is disposed.
    _nameNode.dispose();
    _dateNode.dispose();
    _mileageNode.dispose();
    _repeatNode.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  final TextEditingController _controller = TextEditingController();
  Future _chooseDate(BuildContext context, String initialDateString) async {
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
      _controller.text = DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(DateTime.now());
  }

  InputDecoration defaultInputDecoration(String hintText, String labelText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Theme.of(context).primaryTextTheme.body1,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal),
      ),
      labelText: labelText,
      contentPadding: EdgeInsets.only(
          left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
    );
  }

  Widget repeatField() {
    return TextFormField(
      decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal),
      ),
      labelText: "Repeating Task",
      contentPadding: EdgeInsets.only(
          left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
    ),
    initialValue: (widget.mode == TodoEditMode.EDIT)
        ? widget.existing.repeatingType
        : '',
    autofocus: false,
    focusNode: _repeatNode,
    style: TextStyle(
      fontSize: 22.0,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    keyboardType: TextInputType.text,
    validator: (value) { return null;},
    onSaved: (val) => setState(() => todoItem.repeatingType = val),
    );
  }

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        labelText: "Action Name *",
        contentPadding: EdgeInsets.only(
            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
      ),
      initialValue: (widget.mode == TodoEditMode.EDIT)
          ? widget.existing.name.toString()
          : '',
      autofocus: true,
      focusNode: _nameNode,
      style: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) { return null; },
      onSaved: (val) => setState(() => todoItem.name = val),
    );
  }

  Widget dateField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Optional if Mileage Entered',
        hintStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
        labelText: 'Due Date',
        contentPadding: EdgeInsets.only(
            left: 16.0,
            top: 20.0,
            right: 16.0,
            bottom: 5.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
      focusNode: _dateNode,
      style: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      controller: _controller,
      keyboardType: TextInputType.datetime,
      validator: (val) =>
          isValidDob(val) ? null : 'Not a valid date',
      onSaved: (val) => setState(() {
            if (val != null && val != '') {
              todoItem.dueDate = convertToDate(val);
            }
          }),
    );
  }

  Widget mileageField() {
    return TextFormField(
      decoration: defaultInputDecoration('Optional if Due Date Entered', 'DueMileage'),
      initialValue: (widget.mode == TodoEditMode.EDIT)
          ? widget.existing.dueMileage.toString()
          : '',
      autofocus: false,
      focusNode: _mileageNode,
      style: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.number,
      onSaved: (val) => setState(() {
            if (val != null && val != '') {
              todoItem.dueMileage = int.parse(val);
            }
          }),
    );
  }

  Widget addButton() {
    return Padding(
      padding: EdgeInsets.only(top: 32.0),
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            elevation: 4.0,
            splashColor: Colors.deepPurple,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if (widget.mode == TodoEditMode.CREATE)
                  FirebaseTodoBLoC().push(todoItem);
                else
                  FirebaseTodoBLoC().edit(todoItem);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget autoComplete(FormFieldState<String> input) {
    var txt = _autocompleteController.text;
    if ((txt == null || txt == '') && widget.mode == TodoEditMode.EDIT)
      _autocompleteController.text = widget.existing.repeatingType;
    return AutoCompleteTextField<Repeat>(
      focusNode: _repeatNode,
      controller: _autocompleteController,
      decoration: defaultInputDecoration('Repeating Task', 'Optional'),
      itemSubmitted: (item) => setState(() {
        _autocompleteController.text = item.name;
        selectedRepeat = item;
      }),
      key: _autocompleteKey,
      suggestions: RepeatingBLoC().repeats,
      itemBuilder: (context, suggestion) => Padding(
        child: ListTile(
          title: Text(suggestion.name),
          trailing: Text("Interval: ${suggestion.interval}")
        ),
        padding: EdgeInsets.all(5.0),
      ),
      itemSorter: (a, b) => a.name.length == b.name.length ? 0 : a.name.length < b.name.length ? -1 : 1,
      // returns a match anytime that the input is anywhere in the repeat name
      itemFilter: (suggestion, input) =>
          suggestion.name.toLowerCase().contains(input.toLowerCase()),
    );
  }

  Widget repeatForm() {
    return FormField<String>( 
      builder: autoComplete,
      initialValue: (widget.mode == TodoEditMode.EDIT) ? widget.existing.repeatingType : 'alksjd',
      onSaved: (val) => setState(() {
        if (selectedRepeat != null) todoItem.repeatingType = selectedRepeat.name;
        else if (val != null && RepeatingBLoC().repeats.any((element) => element.name == val)) {
          todoItem.repeatingType = val;
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:
          false, // used to avoid overflow when keyboard is viewable
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Maintenance ToDo'),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(top: 24.0, left: 20.0, right: 20.0),
            controller: scrollCtrl,
            children: <Widget>[
              EnsureVisibleWhenFocused(  
                child: nameField(),
                focusNode: _nameNode,
              ),
              Padding(  
                padding: EdgeInsets.only(bottom: 15),
              ),
              Divider(),
              Padding(  
                padding: EdgeInsets.only(bottom: 15),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: EnsureVisibleWhenFocused(  
                      child: dateField(),
                      focusNode: _dateNode,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    tooltip: 'Choose date',
                    onPressed: (() {
                      _chooseDate(context, _controller.text);
                    }),
                  ),
                ],
              ),
              Padding(  
                padding: EdgeInsets.only(bottom: 15),
              ),
              EnsureVisibleWhenFocused(  
                child: mileageField(),
                focusNode: _mileageNode,
              ),
              Padding(  
                padding: EdgeInsets.only(bottom: 15),
              ),
              AutoScrollField(
                controller: scrollCtrl,
                focusNode: _repeatNode,
                position: 240,
                // child: repeatField(),
                child: repeatForm(),
              ),
              Padding(  
                padding: EdgeInsets.only(bottom: 10),
              ),
              addButton(),
              Container(height: 10000,),
            ],
          ),
        ),
      ),
    );
  }
}
