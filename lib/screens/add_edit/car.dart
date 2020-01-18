import 'package:flutter/material.dart';

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
          title: Text('Edit Car List'),
        ),
        body: Text('Content to come later'),
      );
}
