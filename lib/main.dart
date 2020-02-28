import 'dart:io';
import 'dart:async';

import 'package:autodo/localization.dart';
import 'package:autodo/screens/settings/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:json_intl/json_intl.dart';
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
    await _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}

Future<void> run(bool integrationTest) async {
  final AuthRepository authRepository = FirebaseAuthRepository();
  final theme = createTheme();
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
            BlocProvider<PaidVersionBloc>(
              create: (context) => PaidVersionBloc(
                  dbBloc: BlocProvider.of<DatabaseBloc>(context))
                ..add(LoadPaidVersion()),
            ),
            BlocProvider<NotificationsBloc>(
              create: (context) => NotificationsBloc(
                dbBloc: BlocProvider.of<DatabaseBloc>(context),
              )..add(LoadNotifications()),
            ),
            BlocProvider<RefuelingsBloc>(
              create: (context) => RefuelingsBloc(
                dbBloc: BlocProvider.of<DatabaseBloc>(context),
                // )..add(LoadRefuelings()),
              ),
            ),
          ],
          child: BlocProvider<CarsBloc>(
            create: (context) => CarsBloc(
              dbBloc: BlocProvider.of<DatabaseBloc>(context),
              refuelingsBloc: BlocProvider.of<RefuelingsBloc>(context),
              // )..add(LoadCars()),
            ),
            child: BlocProvider<RepeatsBloc>(
              create: (context) => RepeatsBloc(
                dbBloc: BlocProvider.of<DatabaseBloc>(context),
                carsBloc: BlocProvider.of<CarsBloc>(context),
                // )..add(LoadRepeats()),
              ),
              child: BlocProvider<TodosBloc>(
                create: (context) => TodosBloc(
                    dbBloc: BlocProvider.of<DatabaseBloc>(context),
                    notificationsBloc:
                        BlocProvider.of<NotificationsBloc>(context),
                    carsBloc: BlocProvider.of<CarsBloc>(context),
                    repeatsBloc: BlocProvider.of<RepeatsBloc>(context))
                // ..add(LoadTodos()),
                ,
                child: App(
                    theme: theme,
                    authRepository: authRepository,
                    integrationTest: integrationTest),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<Map> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Map keys = await SecretLoader(secretPath: 'assets/keys.json').load();
  if (Platform.isIOS) {
    await FirebaseApp.configure(
        name: 'autodo',
        options: FirebaseOptions(
          googleAppID: '1:617460744396:ios:7da25d96edce10cefc4269',
          projectID: 'autodo-49f21',
          apiKey: keys['firebase-key'],
        ));
  } else {
    await FirebaseApp.configure(
        name: 'autodo',
        options: FirebaseOptions(
          googleAppID: '1:617460744396:android:400cbb86de167047',
          projectID: 'autodo-49f21',
          apiKey: keys['firebase-key'],
        ));
  }
  InAppPurchaseConnection
      .enablePendingPurchases(); // required in init for Android
  BlocSupervisor.delegate = AutodoBlocDelegate();
  return keys;
}

Future<void> main() async {
  final keys = await init();
  _sentry = SentryClient(dsn: keys['sentry-dsn']);
  await runZoned<Future<void>>(() async {
    await run(false);
  }, onError: _reportError);
}

class App extends StatelessWidget {
  const App({@required theme, @required authRepository, this.integrationTest})
      : assert(theme != null),
        assert(authRepository != null),
        _theme = theme,
        _authRepository = authRepository;

  final ThemeData _theme;

  final AuthRepository _authRepository;

  final bool integrationTest;

  @override
  Widget build(context) {
    final Widget homeProvider =
        HomeScreenProvider(integrationTest: integrationTest);
    final Widget welcomeProvider = WelcomeScreenProvider();
    final Widget signupProvider =
        SignupScreenProvider(authRepository: _authRepository);
    final Widget loginProvider = LoginScreenProvider(
      authRepository: _authRepository,
    );
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          JsonIntl.of(context).get(IntlKeys.appTitle),
      localizationsDelegates: [
        const JsonIntlDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr'),
      ],
      routes: {
        '/': (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
              // Just here as the splitter between home screen and login screen
              builder: (context, state) {
                if (state is RemoteAuthenticated ||
                    state is LocalAuthenticated) {
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
        AutodoRoutes.signupScreen: (context) => signupProvider,
        AutodoRoutes.loginScreen: (context) => loginProvider,
        AutodoRoutes.settingsScreen: (context) => SettingsScreen(),
      },
      theme: _theme,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [BlocProvider.of<PaidVersionBloc>(context).observer],
    );
  }
}
