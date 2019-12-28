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
import 'secret_loader.dart';

SentryClient _sentry;

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map keys = await SecretLoader(secretPath: 'keys.json').load();
  _sentry = SentryClient(dsn: keys['sentry-dsn']);
  FirebaseApp.configure(
      name: 'autodo',
      options: FirebaseOptions(
        googleAppID: '1:617460744396:android:400cbb86de167047',
        projectID: 'autodo-49f21',
        apiKey: keys['firebase-key'],
      ));
  BlocSupervisor.delegate = AutodoBlocDelegate();
  final AuthRepository authRepository = FirebaseAuthRepository();
  // ThemeData theme = AutodoTheme();
  ThemeData theme = createTheme();
  runZoned<Future<void>>(() async {
    runApp(
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(userRepository: authRepository)
          ..add(AppStarted()),
        child: BlocProvider<DatabaseBloc>(
          create: (context) => DatabaseBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          )..add(LoadDatabase()),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NotificationsBloc>(
                create: (context) => NotificationsBloc(
                  dbBloc: BlocProvider.of<DatabaseBloc>(context),
                ),
              ),
              BlocProvider<RefuelingsBloc>(
                create: (context) => RefuelingsBloc(
                  dbBloc: BlocProvider.of<DatabaseBloc>(context),
                ),
              ),
              BlocProvider<RepeatsBloc>(
                create: (context) => RepeatsBloc(
                  dbBloc: BlocProvider.of<DatabaseBloc>(context),
                ),
              ),
            ],
            child: BlocProvider<CarsBloc>(
              create: (context) => CarsBloc(
                dbBloc: BlocProvider.of<DatabaseBloc>(context),
                refuelingsBloc: BlocProvider.of<RefuelingsBloc>(context),
              ),
              child: BlocProvider<TodosBloc>(
                create: (context) => TodosBloc(
                    dbBloc: BlocProvider.of<DatabaseBloc>(context),
                    notificationsBloc:
                        BlocProvider.of<NotificationsBloc>(context),
                    carsBloc: BlocProvider.of<CarsBloc>(context),
                    repeatsBloc: BlocProvider.of<RepeatsBloc>(context)),
                child: App(theme: theme),
              ),
            ),
          ),
        ),
      ),
    );
  }, onError: (error, stackTrace) => _reportError(error, stackTrace));
}

class App extends StatelessWidget {
  final ThemeData _theme;

  App({@required theme})
      : assert(theme != null),
        _theme = theme;

  @override
  build(context) => MaterialApp(
        title: 'auToDo',
        routes: {
          "/": (context) =>
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
