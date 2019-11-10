import 'package:autodo/theme.dart';
import 'package:flutter/material.dart';

import 'package:autodo/util.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/items/items.dart';

enum RepeatEditMode { CREATE, EDIT }

class CreateRepeatScreen extends StatefulWidget {
  final RepeatEditMode mode;
  final Repeat existing;
  CreateRepeatScreen({@required this.mode, this.existing});

  @override 
  CreateRepeatScreenState createState() => CreateRepeatScreenState();
}

class CreateRepeatScreenState extends State<CreateRepeatScreen> {
  Repeat repeat = Repeat.empty();
  final _formKey = GlobalKey<FormState>();
  var filterList;

  CreateRepeatScreenState() {
    filterList = FilteringBLoC().getFiltersAsList();
  }

  Future<void> updateFilters(filter) async => FilteringBLoC().setFilter(filter);

  Widget mileageField() {
    return TextFormField( 
      decoration: defaultInputDecoration('Required', 'Mileage Interval'),
      initialValue: (widget.mode == RepeatEditMode.EDIT) 
        ? widget.existing.interval.toString()
        : '',
      autofocus: false,
      style: Theme.of(context).primaryTextTheme.subtitle,
      keyboardType: TextInputType.number,
      validator: intValidator,
      onSaved: (val) => setState(() => repeat.interval = int.parse(val))
    );
  }

  Widget nameField() {
    return TextFormField( 
      decoration: defaultInputDecoration('Required', 'Task Name'),
      initialValue: (widget.mode == RepeatEditMode.EDIT) 
        ? widget.existing.name
        : '',
      autofocus: true,
      style: Theme.of(context).primaryTextTheme.subtitle,
      keyboardType: TextInputType.text,
      validator: requiredValidator,
      onSaved: (val) => setState(() => repeat.name = val)
    );
  }

  Widget addButton() {
    return Padding(
      padding: EdgeInsets.only(top: 32.0),
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text(
              (widget.mode == RepeatEditMode.CREATE) ? 'ADD' : 'SAVE',
              style: Theme.of(context).primaryTextTheme.button,
            ),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                filterList.forEach((f) {
                  if (f.enabled) repeat.cars.add(f.carName);
                });
                if (widget.mode == RepeatEditMode.CREATE)
                  RepeatingBLoC().push(repeat);
                else {
                  repeat.ref = widget.existing.ref;
                  RepeatingBLoC().edit(repeat);
                }
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget cars() {
    return Container(
      height: 120, 
      child: ListView.builder(
        itemCount: FilteringBLoC().getFilters().keys.length,
        itemBuilder: (context, index) => ListTile(
          leading: Checkbox( 
            value: filterList[index].enabled,
            onChanged: (state) {
              filterList[index].enabled = state; 
              updateFilters(filterList[index]);
              setState(() {});
            },
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          title: Text(filterList[index].carName)
        ),
      ),
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(  
      resizeToAvoidBottomPadding: false, // avoid overflow with keyboard present
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          (widget.mode == RepeatEditMode.CREATE) ? 'New Repeating Task' : 'Edit Repeating Task'
        ),
      ),
      body: Container(  
        child: Form(  
          key: _formKey,
          child: ListView(  
            padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
            children: <Widget>[
              nameField(),
              Padding( 
                padding: EdgeInsets.only(bottom: 15),
              ),
              mileageField(),
              Padding( 
                padding: EdgeInsets.only(bottom: 15),
              ),
              cars(),
              addButton()
            ],
          )
        )
      )
    );
  }
}