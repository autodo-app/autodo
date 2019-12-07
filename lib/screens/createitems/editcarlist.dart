import 'package:flutter/material.dart';

class EditCarListScreen extends StatefulWidget {
  @override
  EditCarListScreenState createState() => EditCarListScreenState();
}

class EditCarListScreenState extends State<EditCarListScreen> {
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
        title: Text('Edit Car List'),
      ),
      // key: _scaffoldKey,
      body: Text('Content to come later'),
    );
  }
}
