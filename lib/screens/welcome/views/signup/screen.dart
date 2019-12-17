import 'package:flutter/widgets.dart';

class SignupScreen extends StatelessWidget {
  @override 
  build(context) => Container();
}
Widget _waitForEmailVerification(user) => AlertDialog(
        title: Text('Verify Email',
            style: Theme.of(context).primaryTextTheme.title),
        content: Text(
            'An email has been sent to you with a link to verify your account.\n\nYou must verify your email to use auToDo.',
            style: Theme.of(context).primaryTextTheme.body1),
        actions: [
          FutureBuilder(
              future: Auth().waitForVerification(user),
              builder: (context, snap) {
                if (!snap.hasData) return Container();
                return FlatButton(
                  child: Text('Next'),
                  onPressed: () =>
                      Navigator.popAndPushNamed(context, '/newuser'),
                );
              })
        ],
      );

  Future<void> _signUp() async {
    if (kReleaseMode) {
      var user = await Auth().signUpWithVerification(_email, _password);
      if (user != null) {
        showDialog(
            context: context,
            builder: (context) => _waitForEmailVerification(user),
            barrierDismissible: false);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      // don't want to deal with using real emails and verifying them in
      // debug
      await initNewUser(_email, _password);
    }
  }