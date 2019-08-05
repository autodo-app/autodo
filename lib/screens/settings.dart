import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
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
        title: Text('Settings'),
      ),
      // key: _scaffoldKey,
      body: Text('Content to come later'),
    );
  }
}
