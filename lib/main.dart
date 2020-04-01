import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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
import 'flavor.dart';
import 'generated/keys.dart';
import 'generated/localization.dart';
import 'repositories/repositories.dart';
import 'routes.dart';
import 'screens/screens.dart';
import 'screens/settings/screen.dart';
import 'theme.dart';
import 'units/units.dart';
import 'widgets/widgets.dart';

SentryClient _sentry;

Future<void> _reportError(
  FlutterErrorDetails details, {
  bool forceReport = false,
}) async {
  if (kFlavor.useSentry) {
    try {
      // Send the Exception and Stacktrace to Sentry
      await _sentry.captureException(
        exception: details.exception,
        stackTrace: details.stack,
      );
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
    }
  }

  // Use Flutter's pretty error logging to the device's console.
  FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
}

Future<void> main() async {
  if (kFlavor.useSentry) {
    _sentry = SentryClient(dsn: Keys.sentryDsn);
  }

  FlutterError.onError = _reportError;
  runApp(AppProvider(false));
}

class AppProvider extends StatefulWidget {
  const AppProvider(this.integrationTest);

  final bool integrationTest;

  @override
  AppProviderState createState() => AppProviderState();
}

class AppProviderState extends State<AppProvider> {
  AuthRepository authRepository;
  ThemeData theme;
  SharedPrefService service;
  final analytics = kFlavor.hasAnalytics ? FirebaseAnalytics() : null;

  Future<void> _configureFirebase() async {
    await FirebaseApp.configure(
      name: kFlavor.firebaseAppName,
      options: FirebaseOptions(
        googleAppID: kFlavor.googleAppID,
        projectID: kFlavor.projectID,
        apiKey: kFlavor.firebaseApiKey,
      ),
    );
  }

  Future<void> _initMainWidget() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _configureFirebase();
    // required in init for Android
    InAppPurchaseConnection.enablePendingPurchases();
    BlocSupervisor.delegate = AutodoBlocDelegate();

    authRepository = FirebaseAuthRepository();
    theme = createTheme();

    final locale = WidgetsBinding.instance.window.locale ?? Locale('en', 'US');
    service = await SharedPrefService.init();
    await service.setDefaultValues({
      'length_unit': Distance.getDefault(locale).index,
      'volume_unit': Volume.getDefault(locale).index,
      'currency': Currency.getDefault(locale),
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initMainWidget(),
      builder: (context, res) {
        if (res.connectionState != ConnectionState.done) {
          return Container();
        }

        return PrefService(
          service: service,
          child: ChangeNotifierProvider<BasePrefService>.value(
            value: service,
            child: BlocProvider<AuthenticationBloc>(
              create: (context) =>
                  AuthenticationBloc(userRepository: authRepository)
                    ..add(AppStarted(integrationTest: widget.integrationTest)),
              child: BlocProvider<DatabaseBloc>(
                create: (context) => DatabaseBloc(
                  authenticationBloc:
                      BlocProvider.of<AuthenticationBloc>(context),
                ),
                child: MultiBlocProvider(
                  providers: [
                    if (kFlavor.hasPaid)
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
                          carsBloc: BlocProvider.of<CarsBloc>(context)),
                      child: App(
                          theme: theme,
                          authRepository: authRepository,
                          integrationTest: widget.integrationTest,
                          analytics: analytics),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class App extends StatelessWidget {
  const App({
    @required ThemeData theme,
    @required AuthRepository authRepository,
    this.integrationTest,
    this.analytics,
  })  : assert(theme != null),
        assert(authRepository != null),
        _theme = theme,
        _authRepository = authRepository;

  final ThemeData _theme;

  final AuthRepository _authRepository;

  final bool integrationTest;

  final FirebaseAnalytics analytics;

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
      navigatorObservers: [
        if (kFlavor.hasPaid) BlocProvider.of<PaidVersionBloc>(context).observer,
        if (analytics != null) FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
