import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:autodo/blocs/todo.dart';
import 'package:autodo/items/items.dart';

class CreateTodoScreen extends StatefulWidget {
  @override
  CreateTodoScreenState createState() => CreateTodoScreenState();
}

class CreateTodoScreenState extends State<CreateTodoScreen> {
  DateTime selectedDate = DateTime.now();
  FocusNode focusNode;
  MaintenanceTodoItem todoItem = MaintenanceTodoItem.empty();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    // todoItem = MaintenanceTodoItem();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();

    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  final TextEditingController _controller = new TextEditingController();
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
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
      // key: _scaffoldKey,
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 24.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        labelText: "Action Name",
                        contentPadding: EdgeInsets.only(
                            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
                      ),
                      // controller: listNameController,
                      autofocus: true,
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 20,
                      validator: (value) {},
                      onSaved: (val) => setState(() => todoItem.name = val),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Divider(),
                    Row(children: <Widget>[
                      new Expanded(
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            icon: const Icon(Icons.calendar_today),
                            hintText: 'Enter your date of birth',
                            labelText: 'Dob',
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
                        ),
                      ),
                      new IconButton(
                        icon: new Icon(Icons.more_horiz),
                        tooltip: 'Choose date',
                        onPressed: (() {
                          _chooseDate(context, _controller.text);
                        }),
                      )
                    ]),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Card(
                      elevation: 1.0,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0),
                      ),
                      margin: EdgeInsets.all(0.0),
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        splashColor:
                            Theme.of(context).primaryColor.withAlpha(30),
                        onTap: () {
                          _selectDate(context);
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Center(
                            child: Text('Other Date',
                                style:
                                    Theme.of(context).primaryTextTheme.button),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        labelText: "Due Mileage",
                        contentPadding: EdgeInsets.only(
                            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
                      ),
                      // controller: listNameController,
                      autofocus: true,
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
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     _selectDate(
                    //         context); // Call Function that has showDatePicker()
                    //   },
                    //   child: IgnorePointer(
                    //     child: new TextFormField(
                    //       decoration: new InputDecoration(hintText: 'DOB'),
                    //       maxLength: 10,
                    //       // validator: validateDob,
                    //       onSaved: (String val) {},
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50.0),
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

                          todoBLoC.push(todoItem);

                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
