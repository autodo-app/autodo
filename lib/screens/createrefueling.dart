import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:autodo/blocs/refueling.dart';
import 'package:autodo/items/items.dart';

enum RefuelingEditMode { CREATE, EDIT }

class CreateRefuelingScreen extends StatefulWidget {
  final RefuelingEditMode mode;
  final RefuelingItem existing;
  CreateRefuelingScreen({@required this.mode, this.existing});

  @override
  CreateRefuelingScreenState createState() => CreateRefuelingScreenState();
}

class CreateRefuelingScreenState extends State<CreateRefuelingScreen> {
  DateTime selectedDate = DateTime.now();
  FocusNode focusNode;
  RefuelingItem refuelingItem;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    refuelingItem = (widget.mode == RefuelingEditMode.EDIT)
        ? widget.existing
        : RefuelingItem.empty();
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
    if (widget.existing != null) print(widget.existing.ref);
    return Scaffold(
      resizeToAvoidBottomPadding:
          false, // used to avoid overflow when keyboard is viewable
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Refueling'),
      ),
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
                        hintText: 'Required',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        labelText: "Odometer Reading (mi)",
                        contentPadding: EdgeInsets.only(
                            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
                      ),
                      autofocus: true,
                      initialValue: (widget.mode == RefuelingEditMode.EDIT)
                          ? widget.existing.odom.toString()
                          : '',
                      keyboardType: TextInputType.number,
                      onSaved: (val) => setState(() {
                            if (val != null && val != '') {
                              refuelingItem.odom = int.parse(val);
                            }
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Required',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        labelText: "Amount of Fuel (gal)",
                        contentPadding: EdgeInsets.only(
                            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
                      ),
                      initialValue: (widget.mode == RefuelingEditMode.EDIT)
                          ? widget.existing.amount.toString()
                          : '',
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => setState(() {
                            if (val != null && val != '') {
                              refuelingItem.amount = double.parse(val);
                            }
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Required',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        labelText: "Total Price (USD)",
                        contentPadding: EdgeInsets.only(
                            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
                      ),
                      // controller: listNameController,
                      initialValue: (widget.mode == RefuelingEditMode.EDIT)
                          ? widget.existing.cost.toString()
                          : '',
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => setState(() {
                            if (val != null && val != '') {
                              refuelingItem.cost = double.parse(val);
                            }
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Row(children: <Widget>[
                      new Expanded(
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            hintText: 'Optional',
                            labelText: 'Refueling Date',
                            contentPadding: EdgeInsets.only(
                                left: 16.0,
                                top: 20.0,
                                right: 16.0,
                                bottom: 5.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                          ),
                          controller: _controller,
                          keyboardType: TextInputType.datetime,
                          validator: (val) =>
                              isValidDob(val) ? null : 'Not a valid date',
                          onSaved: (val) => setState(() {
                                if (val != null && val != '') {
                                  refuelingItem.date = convertToDate(val);
                                }
                              }),
                        ),
                      ),
                      new IconButton(
                        icon: new Icon(Icons.calendar_today),
                        tooltip: 'Choose date',
                        onPressed: (() {
                          _chooseDate(context, _controller.text);
                        }),
                      )
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        'ADD',
                        style: Theme.of(context).accentTextTheme.button,
                      ),
                      color: Theme.of(context).primaryColor,
                      elevation: 4.0,
                      splashColor: Colors.deepPurple,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (widget.mode == RefuelingEditMode.CREATE)
                            FirebaseRefuelingBLoC().push(refuelingItem);
                          else
                            FirebaseRefuelingBLoC().edit(refuelingItem);
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
