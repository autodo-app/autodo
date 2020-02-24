import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

class EditCarListScreen extends StatelessWidget {
  EditCarListScreen({Key key}) : super(key: key);

  @override
  build(context) => Scaffold(
        resizeToAvoidBottomPadding:
            false, // used to avoid overflow when keyboard is viewable
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/'),
          ),
          title: Text(JsonIntl.of(context).get(IntlKeys.editCarList)),
        ),
        body: Text('Content to come later'), // Todo: Add content here
      );
}
