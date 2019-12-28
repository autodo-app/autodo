import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  Widget deleteAccountDialog() {
    return AlertDialog(
      title: Text('Delete Account'),
      content: Text(
          'Deleting your account will permanently remove all data associated with your account.\n\n Are you sure you want to proceed?',
          style: Theme.of(context).primaryTextTheme.body1),
      actions: <Widget>[
        FlatButton(
            onPressed: () =>
                BlocProvider.of<AuthenticationBloc>(context).add(DeletedUser()),
            child: Text('Yes',
                style: Theme.of(context)
                    .primaryTextTheme
                    .button
                    .copyWith(color: Colors.red))),
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No',
                style: Theme.of(context)
                    .primaryTextTheme
                    .button
                    .copyWith(color: Theme.of(context).accentColor))),
      ],
    );
  }

  Widget deleteAccountButton() {
    return FlatButton(
      child: Text('Delete Account',
          style: Theme.of(context)
              .primaryTextTheme
              .button
              .copyWith(color: Colors.red)),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => deleteAccountDialog(),
      ),
    );
  }

  Widget body() {
    return Container(
        child: ListView(
      children: <Widget>[
        deleteAccountButton(),
      ],
    ));
  }

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
      body: body(),
    );
  }
}
