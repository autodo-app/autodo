import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pref/pref.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:json_intl/json_intl.dart';
import 'package:flutter_debug_drawer/flutter_debug_drawer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry/sentry.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:redux_thunk/redux_thunk.dart';

import './redux/app/app_reducer.dart';
import './redux/app/state.dart';
import './repositories/repositories.dart';
import 'flavor.dart';
import 'generated/keys.dart';
import 'generated/localization.dart';
import 'screens/screens.dart';
import 'theme.dart';
import 'units/units.dart';
import 'util.dart';

class AutodoApp extends StatefulWidget {
  const AutodoApp({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  AutodoAppState createState() => AutodoAppState();
}

class AutodoAppState extends State<AutodoApp> {
  bool _authenticated = false;
  bool _initialized = false;
  ThemeData _theme;
  AuthRepository authRepository;
  BasePrefService service;
  final analytics = kFlavor.hasAnalytics ? FirebaseAnalytics() : null;

  Future<Null> _authenticate() async {
    final authenticated = true;
    // final authenticated = LocalAuthentication().authenticate();
    if (authenticated) {
      setState(() => _authenticated = true);
    }
  }

  @override
  void didChangeDependencies() {
    if (!_authenticated) {
      _authenticate();
    }
    _initMainWidget();
    super.didChangeDependencies();
  }

  Future<void> _configureFirebase() async {
    await Firebase.initializeApp(
      name: kFlavor.firebaseAppName,
      options: FirebaseOptions(
        appId: kFlavor.googleAppID,
        projectId: kFlavor.projectID,
        apiKey: kFlavor.firebaseApiKey,
      ),
    );
  }

  Future<void> _initMainWidget() async {
    if (_initialized) {
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();
    await _configureFirebase();
    // required in init for Android
    InAppPurchaseConnection.enablePendingPurchases();

    authRepository = JwtAuthRepository();
    _theme = createTheme();

    final locale = WidgetsBinding.instance.window.locale ?? Locale('en', 'US');
    service = await PrefServiceShared.init();
    await service.setDefaultValues({
      'length_unit': Distance.getDefault(locale).index,
      'volume_unit': Volume.getDefault(locale).index,
      'efficiency_unit': Efficiency.getDefault(locale).index,
      'currency': Currency.getDefault(locale),
    });

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) => StoreProvider<AppState>(
      store: widget.store,
      child: PrefService(
          service: service,
          child: ChangeNotifierProvider<BasePrefService>.value(
              value: service,
              child: MaterialApp(
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
                builder: DebugDrawerBuilder.buildDefault(),
                home: HomeScreen(),
                theme: _theme,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [
                  // if (kFlavor.hasPaid) BlocProvider.of<PaidVersionBloc>(context).observer,
                  // if (analytics != null) FirebaseAnalyticsObserver(analytics: analytics),
                ],
              ))));
}

SentryClient _sentry;

Future<void> _reportError(
    FlutterErrorDetails error, Store<AppState> store) async {
  if (kDebugMode) {
    print(error.stack);
  } else {
    final event = await getSentryEvent(
      state: store.state,
      exception: error.exception,
      stackTrace: error.stack,
    );
    await _sentry.capture(event: event);
  }
}

Future<void> main({bool isTesting = false}) async {
  final _sentry = kFlavor.useSentry
      ? null
      : SentryClient(
          dsn: Keys.sentryDsn, environmentAttributes: await getSentryEvent());
  final store = Store<AppState>(appReducer,
      initialState: AppState(), middleware: [thunkMiddleware]);

  if (_sentry != null) {
    FlutterError.onError =
        (FlutterErrorDetails details) => _reportError(details, store);
  }

  runApp(AutodoApp(store: store));
}
