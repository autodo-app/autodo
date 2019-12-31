import 'dart:async';

import 'package:autodo/screens/add_edit/refueling.dart';
import 'package:autodo/screens/add_edit/repeat.dart';
import 'package:autodo/screens/add_edit/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry/sentry.dart';

import 'widgets/widgets.dart';
import 'blocs/blocs.dart';
import 'screens/screens.dart';
import 'repositories/repositories.dart';
import 'delegate.dart';
import 'routes.dart';
import 'theme.dart';
import 'secret_loader.dart';

SentryClient _sentry;

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
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

void run(bool integrationTest) async {
  final AuthRepository authRepository = FirebaseAuthRepository();
  ThemeData theme = createTheme();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(userRepository: authRepository)
        ..add(AppStarted(integrationTest: integrationTest)),
      child: BlocProvider<DatabaseBloc>(
        create: (context) => DatabaseBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NotificationsBloc>(
              create: (context) => NotificationsBloc(
                dbBloc: BlocProvider.of<DatabaseBloc>(context),
              )..add(LoadNotifications()),
            ),
            BlocProvider<RefuelingsBloc>(
              create: (context) => RefuelingsBloc(
                dbBloc: BlocProvider.of<DatabaseBloc>(context),
              )..add(LoadRefuelings()),
            ),
            BlocProvider<RepeatsBloc>(
              create: (context) => RepeatsBloc(
                dbBloc: BlocProvider.of<DatabaseBloc>(context),
              )..add(LoadRepeats()),
            ),
          ],
          child: BlocProvider<CarsBloc>(
            create: (context) => CarsBloc(
              dbBloc: BlocProvider.of<DatabaseBloc>(context),
              refuelingsBloc: BlocProvider.of<RefuelingsBloc>(context),
            )..add(LoadCars()),
            child: BlocProvider<TodosBloc>(
              create: (context) => TodosBloc(
                  dbBloc: BlocProvider.of<DatabaseBloc>(context),
                  notificationsBloc:
                      BlocProvider.of<NotificationsBloc>(context),
                  carsBloc: BlocProvider.of<CarsBloc>(context),
                  repeatsBloc: BlocProvider.of<RepeatsBloc>(context))
                ..add(LoadTodos()),
              child: App(
                  theme: theme,
                  authRepository: authRepository,
                  integrationTest: integrationTest),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<Map> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map keys = await SecretLoader(secretPath: 'keys.json').load();
  FirebaseApp.configure(
      name: 'autodo',
      options: FirebaseOptions(
        googleAppID: '1:617460744396:android:400cbb86de167047',
        projectID: 'autodo-49f21',
        apiKey: keys['firebase-key'],
      ));
  BlocSupervisor.delegate = AutodoBlocDelegate();
  return keys;
}

void main() async {
  final keys = await init();
  _sentry = SentryClient(dsn: keys['sentry-dsn']);
  runZoned<Future<void>>(() async {
    run(false);
  }, onError: (error, stackTrace) => _reportError(error, stackTrace));
}

class App extends StatelessWidget {
  final ThemeData _theme;
  final AuthRepository _authRepository;
  final bool integrationTest;
  Widget homeProvider, welcomeProvider; // TODO: move these to the build method

  App({@required theme, @required authRepository, this.integrationTest})
      : assert(theme != null),
        assert(authRepository != null),
        _theme = theme,
        _authRepository = authRepository {
    homeProvider = HomeScreenProvider(integrationTest: integrationTest);
    welcomeProvider = WelcomeScreenProvider();
  }

  @override
  build(context) => MaterialApp(
        title: 'auToDo',
        routes: {
          "/": (context) =>
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                // Just here as the splitter between home screen and login screen
                builder: (context, state) {
                  if (state is Authenticated) {
                    return homeProvider;
                  } else if (state is Unauthenticated) {
                    return welcomeProvider;
                  } else {
                    return LoadingIndicator();
                  }
                },
              ),
          AutodoRoutes.home: (context) => homeProvider,
          AutodoRoutes.welcome: (context) => welcomeProvider,
          AutodoRoutes.signupScreen: (context) =>
              SignupScreenProvider(authRepository: _authRepository),
          AutodoRoutes.loginScreen: (context) => 
            LoginScreenProvider(authRepository: _authRepository),
        },
        theme: _theme,
        debugShowCheckedModeBanner: false,
      );
}
