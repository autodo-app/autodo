import 'package:flutter_driver/driver_extension.dart';
import 'package:autodo/main.dart' as app;

Future<void> main() async {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // run the app
  // await app.init();
  // await app.run(true);
  app.run(true);
}
