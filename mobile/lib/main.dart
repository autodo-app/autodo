import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:json_intl/json_intl.dart';
import 'package:flutter_debug_drawer/flutter_debug_drawer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry/sentry.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'flavor.dart';
import 'generated/keys.dart';
import 'generated/localization.dart';
import 'models/models.dart';
import 'redux/redux.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';
import 'theme.dart';
import 'units/units.dart';
import 'util.dart';

class AutodoApp extends StatefulWidget {
  const AutodoApp({Key key, @required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  AutodoAppState createState() => AutodoAppState();
}

class AutodoAppState extends State<AutodoApp> {
  bool _authenticated = false;
  bool _initialized = false;
  ThemeData _theme;
  final analytics = kFlavor.hasAnalytics ? FirebaseAnalytics() : null;

  Future<Null> _authenticate() async {
    // TODO: what is this??
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
    // await Firebase.initializeApp(
    //   name: kFlavor.firebaseAppName,
    //   options: FirebaseOptions(
    //     appId: kFlavor.googleAppID,
    //     projectId: kFlavor.projectID,
    //     apiKey: kFlavor.firebaseApiKey,
    //   ),
    // );
  }

  Future<void> _initMainWidget() async {
    if (_initialized) {
      return;
    }

    await _configureFirebase();
    // required in init for Android
    InAppPurchaseConnection.enablePendingPurchases();

    _theme = createTheme();

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) => StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
        onGenerateTitle: (BuildContext context) {
          // Write the json intl localization to the redux store
          widget.store.dispatch(SetIntlAction(JsonIntl.of(context)));
          return JsonIntl.of(context).get(IntlKeys.appTitle);
        },
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
      ));
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
  WidgetsFlutterBinding.ensureInitialized();

  final locale = WidgetsBinding.instance.window.locale ?? Locale('en', 'US');

  final store = Store<AppState>(
    appReducer,
    initialState: AppState(
      api: AutodoApi(),
      authState: AuthState(
        status: AuthStatus.IDLE,
        error: null,
        token: null,
        isUserVerified: false,
      ),
      dataState: DataState(
        status: DataStatus.IDLE,
        refuelings: [],
        cars: [],
        todos: [],
        error: null,
      ),
      filterState: FilterState(
        refuelingsFilter: VisibilityFilter.all,
        todosFilter: VisibilityFilter.all,
      ),
      intlState: IntlState(
        intl: null, // will need to load this at run-time
      ),
      paidVersionState: PaidVersionState(
        isPaid: true,
        status: PaidVersionStatus.IDLE,
      ),
      statsState: StatsState(
        status: StatsStatus.IDLE,
        fuelEfficiency: FuelEfficiencyData({}),
        fuelUsageByCar: FuelUsageCarData({}),
        drivingRate: DrivingRateData({}),
        fuelUsageByMonth: FuelUsageMonthData({}),
        error: null,
      ),
      unitsState: UnitsState(
        distance: Distance(Distance.getDefault(locale), locale),
        volume: Volume(Volume.getDefault(locale), locale),
        efficiency: Efficiency(Efficiency.getDefault(locale), locale),
        currency: Currency(Currency.getDefault(locale), locale),
      ),
    ),
    middleware: [thunkMiddleware],
  );

  final _sentry = kFlavor.useSentry
      ? null
      : SentryClient(
          dsn: Keys.sentryDsn, environmentAttributes: await getSentryEvent());
  if (_sentry != null) {
    FlutterError.onError =
        (FlutterErrorDetails details) => _reportError(details, store);
  }

  runApp(AutodoApp(
    store: store,
  ));
}
