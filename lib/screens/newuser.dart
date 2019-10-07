import 'package:flutter/material.dart';
import 'package:autodo/blocs/carstats.dart';
import 'package:autodo/theme.dart';

class NewUserScreen extends StatefulWidget {
  @override
  NewUserScreenState createState() => NewUserScreenState();
}

class NewUserScreenState extends State<NewUserScreen> {
  Widget field = TextFormField(
      maxLines: 1,
      obscureText: true,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Car Mileage',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
      ),
      validator: (value) =>  null,
      onSaved: (value) => CarStatsBLoC().setCurrentMileage(int.parse(value.trim())),
    );
    
  Widget initCarMileage() {
    Widget headerText = Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
      child: Center(
        child: Text(  
          'How many miles are currently on your car?',
          style: Theme.of(context).primaryTextTheme.body1,
        ),
      ),
    );

    Widget card = Expanded( 
      child: Container( 
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(  
          borderRadius: BorderRadius.only(
            topRight:  Radius.circular(30),
            topLeft:  Radius.circular(30),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[  
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: field,
            ),
            Padding( 
              padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                children: <Widget>[
                  FlatButton( 
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () => Navigator.popAndPushNamed(context, '/'),
                  ),
                  FlatButton( 
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      'Next',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () => Navigator.popAndPushNamed(context, '/'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );  

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          headerText,
          card,
        ],
      ),
    );
  } 

  Widget initRepeats() {
    Widget headerText = Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
      child: Center(
        child: Text(  
          'How often do you want to do these tasks?',
          style: Theme.of(context).primaryTextTheme.body1,
        ),
      ),
    );

    Widget card = Expanded( 
      child: Container( 
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(  
          borderRadius: BorderRadius.only(
            topRight:  Radius.circular(30),
            topLeft:  Radius.circular(30),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[  
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: field,
            ),
            Padding( 
              padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                children: <Widget>[
                  FlatButton( 
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () => Navigator.popAndPushNamed(context, '/'),
                  ),
                  FlatButton( 
                    padding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: Text(
                      'Next',
                      style: Theme.of(context).primaryTextTheme.button,
                    ),
                    onPressed: () => Navigator.popAndPushNamed(context, '/'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );  

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          headerText,
          card,
        ],
      ),
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Container(
      decoration: scaffoldBackgroundGradient(),
      child: Scaffold(
        appBar: AppBar(  
          leading: IconButton( 
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: initCarMileage(),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}