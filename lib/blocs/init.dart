import 'package:autodo/blocs/filtering.dart';
import 'package:autodo/blocs/repeating.dart';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:flutter/material.dart';

/// Initializes the content for all of the BLoCs
/// in the proper order to prevent issues with
/// their data not being populated.
Future<void> initBLoCs(String uuid) async {
  print('uias $uuid');
  await FirestoreBLoC().setUserDocument(uuid)
    .then((_) => RepeatingBLoC().updateUpcomingTodos())
    .then((_) => FilteringBLoC().initialize());
}

/// Signs up a new user and creates their user document
/// in the database.
Future<void> initNewUser(String email, String password) async {
  String uuid = await Auth().signUp(email, password);
  if (uuid == null || uuid == "")
    throw SignInFailure();
  await FirestoreBLoC().createUserDocument(uuid);
  await initBLoCs(uuid);
}

Future<void> loadingSequence(BuildContext context) async {
  String uuid = await Auth().fetchUser();
  if (uuid == "NO_USER") {
    Navigator.pushNamed(context, '/welcomepage');
  } else {
    await initBLoCs(uuid);
    Navigator.pushNamed(context, '/');
  }
}

Future<void> initExistingUser(String email, String password) async {
  String uuid = await Auth().signIn(email, password);
  if (uuid == null || uuid == "")
    throw SignInFailure();
  await initBLoCs(uuid);
}
