import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoginButton extends StatelessWidget {
  final buttonPadding;

  LoginButton({Key key, this.buttonPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, buttonPadding, 0.0, buttonPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Already have an account?',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pushNamed(context, '/loginpage'),
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Text(
                "LOG IN",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
