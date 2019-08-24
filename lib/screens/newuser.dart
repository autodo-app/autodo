import 'package:flutter/material.dart';
import '../blocs/userauth.dart';

class SignUpScreen extends StatefulWidget {
  final Auth userAuth = Auth();
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  void handleError(Object exception, StackTrace trace) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Hero(
          tag: "SignupButton",
          transitionOnUserGestures: true,
          child: SafeArea(
            child: RaisedButton(
              onPressed: () async {
                await widget.userAuth
                    .signUp("baylessjonathan@gmail.com", "test123")
                    .catchError(handleError);
              },
            ),
          ),
        ),
      ),
    );
  }
}
