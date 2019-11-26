import 'package:autodo/blocs/filtering.dart';
import 'package:autodo/blocs/repeating.dart';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:flutter/material.dart';

/// Initializes the content for all of the BLoCs
/// in the proper order to prevent issues with
/// their data not being populated.
Future<void> initBLoCs(String uuid) async {
  FirestoreBLoC().setUserDocument(uuid);
  print('askl $uuid');
  await RepeatingBLoC().updateUpcomingTodos();
  await FilteringBLoC().initialize();
}

void startListeners() {
  FirestoreBLoC().initialize();
}

/// Signs up a new user and creates their user document
/// in the database.
Future<void> initNewUser(String email, String password) async {
  FirestoreBLoC().initialize(); // starts listening for auth change
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
  FirestoreBLoC().initialize(); // starts listening for auth change
  String uuid = await Auth().signIn(email, password);
  if (uuid == null || uuid == "")
    throw SignInFailure();
  await initBLoCs(uuid);
}
