import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_intl/json_intl.dart';

import '../../blocs/blocs.dart';
import '../../flavor.dart';
import '../../integ_test_keys.dart';
import '../../models/models.dart';
import '../../screens/welcome/views/barrel.dart';
import '../../units/units.dart';
import '../../widgets/widgets.dart';
import '../add_edit/barrel.dart';
import 'views/barrel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key = IntegrationTestKeys.homeScreen,
    this.todosTabKey,
    this.integrationTest = false,
    this.tab = AppTab.todos,
  }) : super(key: key);

  final Key todosTabKey;

  final bool integrationTest;

  final AppTab tab;

  @override
  HomeScreenState createState() =>
      HomeScreenState(todosTabKey, integrationTest);
}

class _ScreenWithBanner extends StatelessWidget {
  const _ScreenWithBanner({this.child, this.bannerShown = true});

  final Widget child;

  final bool bannerShown;

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: child),
          ...bannerShown
              ? [Container(height: 50, color: Theme.of(context).cardColor)]
              : []
        ],
      ));
}

class HomeScreenState extends State<HomeScreen> with RouteAware {
  HomeScreenState(this.todosTabKey, this.integrationTest);

  final Map<AppTab, Widget> views = {
    AppTab.todos: TodosScreen(),
    AppTab.refuelings: RefuelingsScreen(),
    AppTab.stats: StatisticsScreen(),
    AppTab.garage: GarageScreen(),
  };

  final Key todosTabKey;

  final bool integrationTest;

  BannerAd _bannerAd;

  bool _bannerShown = false;

  static bool _adMobInitialized = false;

  AppTab _tab;

  AppTab get tab => _tab;

  StreamSubscription<DataState> dataSubscription;

  set tab(AppTab tab) {
    setState(() {
      _tab = tab;
    });
  }

  // this has to be a function so that it returns a different route each time
  // the lifecycle of a MaterialPageRoute requires that it not be reused.
  List<MaterialPageRoute> Function() fabRoutes(List<Car> cars) => () => [
        MaterialPageRoute(
          builder: (context) => _ScreenWithBanner(
            child: RefuelingAddEditScreen(
              isEditing: false,
              onSave: (m, d, a, c, n) {
                BlocProvider.of<DataBloc>(context).add(AddRefueling(Refueling(
                  odomSnapshot: OdomSnapshot(
                      car: n, // TODO: return Car ID here
                      mileage:
                          Distance.of(context, listen: false).unitToInternal(m),
                      date: d),
                  amount: Volume.of(context, listen: false).unitToInternal(a),
                  cost: Currency.of(context, listen: false).unitToInternal(c),
                )));
              },
              cars: cars,
            ),
          ),
        ),
        MaterialPageRoute(
            builder: (context) => _ScreenWithBanner(
                    child: TodoAddEditScreen(
                  isEditing: false,
                  onSave: (n, d, m, c, mR, dR) {
                    // TODO: return Car ID here
                    BlocProvider.of<DataBloc>(context).add(AddTodo(Todo(
                        name: n,
                        dueDate: d,
                        dueMileage: m,
                        carId: c,
                        mileageRepeatInterval: mR,
                        dateRepeatInterval: dR,
                        completed: false)));
                  },
                ))),
        MaterialPageRoute(
            builder: (context) => _ScreenWithBanner(
                    child: CarAddEditScreen(
                  isEditing: false,
                  onSave: (name, odom, make, model, y, p, v) {
                    BlocProvider.of<DataBloc>(context).add(TranslateDefaults(
                        JsonIntl.of(context),
                        Distance.of(context, listen: false).unit));
                    BlocProvider.of<DataBloc>(context).add(AddCar(Car(
                        name: name,
                        odomSnapshot:
                            OdomSnapshot(mileage: odom, date: DateTime.now()),
                        make: make,
                        model: model,
                        year: y,
                        plate: p,
                        vin: v)));
                  },
                ))),
      ];

  Widget get actionButton =>
      BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        if (!(state is DataLoaded)) {
          print('Cannot show fab without cars');
          return Container();
        } else if (integrationTest) {
          return AutodoActionButton(
              miniButtonRoutes: fabRoutes((state as DataLoaded).cars),
              ticker: TestVSync());
        } else {
          return AutodoActionButton(
              miniButtonRoutes: fabRoutes((state as DataLoaded).cars));
        }
      });

  AutodoBannerAd _bannerAdConfig() => AutodoBannerAd(
        adUnitId: kReleaseMode
            ? 'ca-app-pub-6809809089648617/3864738913'
            : BannerAd.testAdUnitId,
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (kFlavor.hasPaid) {
      BlocProvider.of<PaidVersionBloc>(context)
          .observer
          .subscribe(this, ModalRoute.of(context));
    }

    dataSubscription ??= BlocProvider.of<DataBloc>(context).listen((a) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    dataSubscription?.cancel();
    dataSubscription = null;
    super.dispose();
  }

  @override
  Future<void> didPush() async {
    // Route was pushed onto navigator and is now topmost route.

    if (kFlavor.hasAds && ModalRoute.of(context).isCurrent) {
      _bannerShown = true;
      await _bannerAd?.dispose(); // clear old banner ad if one exists
      _bannerAd = _bannerAdConfig();
      // ignore: unawaited_futures
      _bannerAd.load().then((value) => _bannerAd.show());
    }
  }

  @override
  Future<void> didPop() async {
    // Current route was popped off the navigator.
    if (kFlavor.hasAds && _bannerShown) {
      _bannerShown = false;
      await _bannerAd?.dispose(); // clear old banner ad if one exists
    }
  }

  @override
  Future<void> didPushNext() async {
    // Another route is now above this route
    if (kFlavor.hasAds && _bannerShown) {
      _bannerShown = false;
      await _bannerAd?.dispose(); // clear old banner ad if one exists
    }
    super.didPushNext();
  }

  @override
  void initState() {
    _tab = widget.tab;
    if (kFlavor.hasAds && !_adMobInitialized) {
      FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
      _adMobInitialized = true;
    }

    super.initState();
  }

  List<Widget> fakeBottomButtons = [Container(height: 50)];

  Widget buildScreen(BuildContext context) {
    return Scaffold(
      body: views[_tab],
      floatingActionButton: actionButton,
      bottomNavigationBar: TabSelector(
        activeTab: _tab,
        onTabSelected: (_tab) => tab = _tab,
        todosTabKey: todosTabKey,
        refuelingsTabKey: ValueKey('__refuelings_tab_button__'),
        garageTabKey: ValueKey('__garage_tab_button__'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataState = BlocProvider.of<DataBloc>(context).state;
    if (dataState is DataLoaded) {
      if (dataState.cars.isEmpty) {
        return NewUserScreen();
      }
    } else {
      return LoadingIndicator();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<FilteredRefuelingsBloc>(
            create: (context) => FilteredRefuelingsBloc(
                dataBloc: BlocProvider.of<DataBloc>(context))),
        BlocProvider<FilteredTodosBloc>(
            create: (context) => FilteredTodosBloc(
                dataBloc: BlocProvider.of<DataBloc>(context))),
      ],
      child: kFlavor.hasAds
          ? (kFlavor.hasPaid
              ? BlocBuilder<PaidVersionBloc, PaidVersionState>(
                  builder: (context, paid) {
                  if (paid is PaidVersion && _bannerShown) {
                    _bannerAd?.dispose()?.then((_) {
                      setState(() {
                        _bannerShown = false;
                      });
                    });
                  }
                  return buildScreen(context);
                })
              : _ScreenWithBanner(
                  bannerShown: _bannerShown,
                  child: buildScreen(context),
                ))
          : buildScreen(context),
    );
  }
}
