import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:json_intl/json_intl.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

import 'blocs/blocs.dart';
import 'delegate.dart';
import 'generated/localization.dart';
import 'repositories/repositories.dart';
import 'routes.dart';
import 'screens/screens.dart';
import 'screens/settings/screen.dart';
import 'secret_loader.dart';
import 'theme.dart';
import 'units/units.dart';
import 'widgets/widgets.dart';

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

  final locale = WidgetsBinding.instance.window.locale ?? Locale('en', 'US');
  final service = await SharedPrefService.init();
  await service.setDefaultValues({
    'length_unit': Distance.getDefault(locale).index,
    'volume_unit': Volume.getDefault(locale).index,
    'currency': Currency.getDefault(locale),
  });

  runApp(
    PrefService(
      service: service,
      child: ChangeNotifierProvider<BasePrefService>.value(
        value: service,
        child: BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: authRepository)
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
      ),
    ),
  );
}

Future<void> configureFirebase(keys) async {
  String googleAppID, projectID, apiKey;
  if (kReleaseMode) {
    apiKey = keys['firebase-prod-key'];
    projectID = 'autodo-e93fc';
    if (Platform.isIOS) {
      googleAppID = '1:356275435347:ios:4e46f5fa8de51c6faad3a6';
    } else {
      googleAppID = '1:356275435347:android:5d33ed5a0494d852aad3a6';
    }
  } else {
    apiKey = keys['firebase-test-key'];
    projectID = 'autodo-49f21';
    if (Platform.isIOS) {
      googleAppID = '1:617460744396:ios:7da25d96edce10cefc4269';
    } else {
      googleAppID = '1:617460744396:android:400cbb86de167047';
    }
  }

  await FirebaseApp.configure(
      name: 'autodo',
      options: FirebaseOptions(
        googleAppID: googleAppID,
        projectID: projectID,
        apiKey: apiKey,
      ));
}

Future<Map> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Map keys = await SecretLoader(secretPath: 'assets/keys.json').load();
  await configureFirebase(keys);
  InAppPurchaseConnection
      .enablePendingPurchases(); // required in init for Android
  BlocSupervisor.delegate = AutodoBlocDelegate();
  return keys;
}

Future<void> main() async {
  final keys = await init();
  _sentry = SentryClient(dsn: keys['sentry-dsn']);
  await runZonedGuarded<Future<void>>(() async {
    await run(false);
  }, _reportError);
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
