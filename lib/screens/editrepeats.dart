import 'package:flutter/material.dart';
import 'package:autodo/blocs/repeating.dart';

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
      child: RepeatingBLoC().buildList(context),
    );
  }
}
