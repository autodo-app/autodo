import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry/sentry.dart';

import 'widgets/widgets.dart';
import 'blocs/blocs.dart';
import 'screens/home/provider.dart';
import 'screens/welcome/provider.dart';
import 'repositories/repositories.dart';
import 'delegate.dart';
import 'routes.dart';
import 'theme.dart';

final SentryClient _sentry = SentryClient(dsn: "https://20c77d8ea8634cb68f64d31a70a43add@sentry.io/1865109");

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  if (!kReleaseMode) {
    // Print the full stacktrace in debug mode.
    print(stackTrace);
    return;
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode.
    _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp.configure(
    name: 'autodo',
    options: FirebaseOptions(
      googleAppID: '1:617460744396:android:400cbb86de167047',
      projectID: 'autodo-49f21',
      apiKey: 'AIzaSyAAYhwsJVyiYywUFORBgaUuyXqXFiFpbZo',
    )
  );
  BlocSupervisor.delegate = AutodoBlocDelegate();
  final AuthRepository authRepository = FirebaseAuthRepository();
  // ThemeData theme = AutodoTheme();
  ThemeData theme = createTheme();
  runZoned<Future<void>>(() async {
    runApp(
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            userRepository: authRepository
          )..add(AppStarted()),
        child: BlocProvider<DatabaseBloc>(  
          create: (context) => DatabaseBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          )..add(LoadDatabase()),
          child: App(theme: theme),
        ),
      ),
    );
  }, onError: (error, stackTrace) => _reportError(error, stackTrace));
}

class App extends StatelessWidget {
  final ThemeData _theme;

  App({@required theme}) : assert(theme != null), _theme = theme;

  @override
  build(context) => MaterialApp(
    title: 'auToDo',
    routes: {
      "/": (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>( 
        // Just here as the splitter between home screen and login screen
        builder: (context, state) {
          if (state is Authenticated) {
            return HomeScreenProvider();
          } else if (state is Unauthenticated) {
            return WelcomeScreenProvider();
          } else {
            return LoadingIndicator();
          }
        },
        bloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      AutodoRoutes.home: (context) => HomeScreenProvider(),
      AutodoRoutes.welcome: (context) => WelcomeScreenProvider(),
    },
    theme: _theme,
    debugShowCheckedModeBanner: false,
  );
}