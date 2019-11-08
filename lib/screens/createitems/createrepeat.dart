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
              'ADD',
              style: Theme.of(context).primaryTextTheme.button,
            ),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if (widget.mode == RepeatEditMode.CREATE)
                  RepeatingBLoC().push(repeat);
                else
                  RepeatingBLoC().edit(repeat);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
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
        title: Text('New Repeating Task'),
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
              addButton()
            ],
          )
        )
      )
    );
  }
}