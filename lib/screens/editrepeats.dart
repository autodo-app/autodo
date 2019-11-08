import 'package:flutter/material.dart';
import 'package:autodo/blocs/repeating.dart';

class EditRepeatsScreen extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  void save() {
    if (_formKey.currentState.validate())
      _formKey.currentState.save();
  }

  @override
  EditRepeatsScreenState createState() => EditRepeatsScreenState();
}

class EditRepeatsScreenState extends State<EditRepeatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: RepeatingBLoC().items(),
    );
  }
}
