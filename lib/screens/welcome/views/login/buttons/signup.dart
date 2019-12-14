import 'package:flutter/material.dart';
import '../../signup/screen.dart';

class CreateAccountButton extends StatelessWidget {
  CreateAccountButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return SignupScreen();
          }),
        );
      },
    );
  }
}