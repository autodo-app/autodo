import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/sharedmodels/sharedmodels.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/util.dart';

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

  TextEditingController _autocompleteController;
  Car selectedCar;
  final _autocompleteKey = GlobalKey<AutoCompleteTextFieldState<Car>>();
  List<Car> cars;
  final TextEditingController _controller = TextEditingController();

  void setCars() async {
    var carList = await CarsBLoC().getCars();
    // update the autocomplete field
    _autocompleteKey.currentState.updateSuggestions(carList);
    setState(() => cars = carList);
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    refuelingItem = (widget.mode == RefuelingEditMode.EDIT)
        ? widget.existing
        : RefuelingItem.empty();
    _autocompleteController = TextEditingController();
    setCars();
    if (widget.existing != null && widget.existing.date != null) {
      _controller.text = DateFormat.yMd().format(widget.existing.date);
    }  
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
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

  Widget autoComplete(FormFieldState<String> input) {
    var txt = _autocompleteController.text;
    if ((txt == null || txt == '') && widget.mode == RefuelingEditMode.EDIT)
      _autocompleteController.text = widget.existing.carName;
    return AutoCompleteTextField<Car>(
      controller: _autocompleteController,
      decoration: defaultInputDecoration('Required', 'Car Name'),
      itemSubmitted: (item) => setState(() {
        _autocompleteController.text = item.name;
        selectedCar = item;
        print(item.name);
      }),
      key: _autocompleteKey,
      focusNode: focusNode,
      suggestions: cars,
      itemBuilder: (context, suggestion) => Padding(
        child: ListTile(
          title: Text(suggestion.name),
          trailing: Text("Mileage: ${suggestion.mileage}")
        ),
        padding: EdgeInsets.all(5.0),
      ),
      itemSorter: (a, b) => a.name.length == b.name.length ? 0 : a.name.length < b.name.length ? -1 : 1,
      // returns a match anytime that the input is anywhere in the repeat name
      itemFilter: (suggestion, input) {
        return suggestion.name.toLowerCase().contains(input.toLowerCase());
      },
    );
  }

  Widget carForm() {
    return FormField<String>( 
      builder: autoComplete,
      initialValue: (widget.mode == RefuelingEditMode.EDIT) ? widget.existing.carName : '',
      // validator: requiredValidator,
      // for some reason the validator is never given the value?
      onSaved: (val) => setState(() {
        if (selectedCar != null) refuelingItem.carName = selectedCar.name;
        else if (val != null && cars.any((element) => element.name == val)) {
          refuelingItem.carName = val;
        }
      }),
    );
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
                        validator: intValidator,
                        onSaved: (val) => setState(() => refuelingItem.odom = int.parse(val)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                    ),
                    carForm(),
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
                        validator: doubleValidator,
                        onSaved: (val) => setState(() => refuelingItem.amount = double.parse(val)
                      ),
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
                        initialValue: (widget.mode == RefuelingEditMode.EDIT)
                            ? widget.existing.cost.toString()
                            : '',
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        validator: doubleValidator,
                        onSaved: (val) => setState(() => refuelingItem.cost = double.parse(val)
                      ),
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
                      IconButton(
                        icon: Icon(Icons.calendar_today),
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
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (widget.mode == RefuelingEditMode.CREATE)
                            RefuelingBLoC().push(refuelingItem);
                          else
                            RefuelingBLoC().edit(refuelingItem);
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
