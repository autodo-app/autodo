import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

BoxDecoration bgGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.blue, Colors.red],
    ),
  );
}

Widget nextButton(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 30.0),
    child: FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'next',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.0),
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 20.0,
          ),
        ],
      ),
      onPressed: () => Navigator.pushNamed(context, '/'),
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: bgGradient(),
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  'Welcome to auToDo!',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: nextButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TutorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: bgGradient(),
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  'auToDo has two main focuses:\nOrganizing Maintenance ToDo Items,\nand keeping track of your car\'s refuelings.',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: nextButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
