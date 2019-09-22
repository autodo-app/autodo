import 'package:flutter/material.dart';
import 'package:autodo/blocs/repeating.dart';
import 'package:autodo/items/repeat.dart';

class EditRepeatsScreen extends StatefulWidget {
  @override
  EditRepeatsScreenState createState() => EditRepeatsScreenState();
}

class EditRepeatsScreenState extends State<EditRepeatsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomPadding:
            false, // used to avoid overflow when keyboard is viewable
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.pop(context);
              }
            },
          ),
          title: Text("Edit Repeated Tasks"),
        ),
        body: Container(
          child: RepeatingBLoC().buildList(context),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            RepeatingBLoC().pushRepeats('default', [Repeat.empty()]);
          },
        ),
      ),
    );
  }
}
