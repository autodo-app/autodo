import 'package:autodo/blocs/filtering.dart';
import 'package:autodo/blocs/firestore.dart';
import 'package:autodo/blocs/repeating.dart';
import 'package:autodo/blocs/userauth.dart';

/// Initializes the content for all of the BLoCs
/// in the proper order to prevent issues with
/// their data not being populated.
Future<void> initBLoCs(String uuid) async {
  FirestoreBLoC().setUserDocument(uuid);
  await RepeatingBLoC().updateUpcomingTodos();
  await FilteringBLoC().initialize();
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