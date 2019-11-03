import 'package:autodo/blocs/filtering.dart';
import 'package:autodo/blocs/repeating.dart';

/// Initializes the content for all of the BLoCs
/// in the proper order to prevent issues with
/// their data not being populated.
Future<void> initBLoCs() async {
  await RepeatingBLoC().updateUpcomingTodos();
  await FilteringBLoC().initialize();
}