import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../flavor.dart';
import '../../integ_test_keys.dart';
import '../../models/models.dart';
import '../../redux/redux.dart';
import '../../screens/welcome/screen.dart';
import '../../screens/welcome/views/barrel.dart';
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
  _HomeScreenState createState() =>
      _HomeScreenState(todosTabKey, integrationTest);
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

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent(this.vm, this.integrationTest);

  final _ViewModel vm;
  final bool integrationTest;

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  _HomeScreenContentState();

  AppTab _tab = AppTab.todos;

  final Map<AppTab, Widget> views = {
    AppTab.todos: TodosScreen(),
    AppTab.refuelings: RefuelingsScreen(),
    AppTab.stats: StatisticsScreen(),
    AppTab.garage: GarageScreen(),
  };

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
              onSave: widget.vm.onRefuelingAdded,
              cars: cars,
            ),
          ),
        ),
        MaterialPageRoute(
          builder: (context) => _ScreenWithBanner(
            child: TodoAddEditScreen(
              cars: widget.vm.cars,
              isEditing: false,
              onSave: widget.vm.onTodoAdded,
            ),
          ),
        ),
        MaterialPageRoute(
          builder: (context) => _ScreenWithBanner(
            child: CarAddEditScreen(
                isEditing: false, onSave: widget.vm.onCarAdded),
          ),
        ),
      ];

  Widget get actionButton {
    if (widget.vm.cars.isEmpty) {
      print('Cannot show fab without cars');
      return Container();
    } else if (widget.integrationTest) {
      return AutodoActionButton(
          miniButtonRoutes: fabRoutes(widget.vm.cars), ticker: TestVSync());
    } else {
      return AutodoActionButton(miniButtonRoutes: fabRoutes(widget.vm.cars));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[_tab],
      floatingActionButton: actionButton,
      bottomNavigationBar: TabSelector(
        activeTab: _tab,
        onTabSelected: (_tab) => tab = _tab,
        todosTabKey: ValueKey('__todos_tab_button__'),
        refuelingsTabKey: ValueKey('__refuelings_tab_button__'),
        garageTabKey: ValueKey('__garage_tab_button__'),
      ),
    );
  }
}

/// A wrapper around the actual home screen content for the banner ads
class _HomeScreenState extends State<HomeScreen> with RouteAware {
  _HomeScreenState(this.todosTabKey, this.integrationTest);

  final Key todosTabKey;

  final bool integrationTest;

  BannerAd _bannerAd;

  bool _bannerShown = false;

  static bool _adMobInitialized = false;

  bool get adsEnabled => kFlavor.hasAds && kFlavor.hasPaid;
  bool removeAdsBanner(vm) => adsEnabled && !vm.isPaidVersion && _bannerShown;

  AutodoBannerAd _bannerAdConfig() => AutodoBannerAd(
        adUnitId: kReleaseMode
            ? 'ca-app-pub-6809809089648617/3864738913'
            : BannerAd.testAdUnitId,
      );

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
    if (kFlavor.hasAds && !_adMobInitialized) {
      FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
      _adMobInitialized = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          print('${vm.authStatus}  ${vm.dataStatus}');
          if (vm.authStatus == AuthStatus.IDLE) {
            return LoadingIndicator();
          } else if (vm.authStatus == AuthStatus.LOGGED_OUT) {
            return WelcomeScreen();
          }

          if (vm.dataStatus == DataStatus.IDLE) {
            return LoadingIndicator();
          } else if (vm.cars.isEmpty) {
            return NewUserScreen();
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => NewUserScreen()));
          }

          if (adsEnabled) {
            if (removeAdsBanner(vm)) {
              _bannerAd?.dispose()?.then((_) {
                setState(() {
                  _bannerShown = false;
                });
              });
              return HomeScreenContent(vm, integrationTest);
            }
            return _ScreenWithBanner(
                bannerShown: _bannerShown,
                child: HomeScreenContent(vm, integrationTest));
          }
          return HomeScreenContent(vm, integrationTest);
        },
      );
}

class _ViewModel {
  const _ViewModel(
      {@required this.isPaidVersion,
      @required this.authStatus,
      @required this.dataStatus,
      @required this.cars,
      @required this.onRefuelingAdded,
      @required this.onTodoAdded,
      @required this.onCarAdded});

  final bool isPaidVersion;

  final AuthStatus authStatus;

  final DataStatus dataStatus;

  final List<Car> cars;

  final Function(double, DateTime, double, double, String) onRefuelingAdded;

  final Function(String, DateTime, double, String, double, RepeatInterval)
      onTodoAdded;

  final Function(String, double, String, String, int, String, String)
      onCarAdded;

  static _ViewModel fromStore(Store<AppState> store) {
    final authStatus = store.state.authState.status;
    final dataStatus = store.state.dataState.status;
    if (authStatus == AuthStatus.IDLE) {
      store.dispatch(checkLoginStatus);
    }
    if (authStatus == AuthStatus.LOGGED_IN && dataStatus == DataStatus.IDLE) {
      store.dispatch(fetchData);
    }

    return _ViewModel(
        isPaidVersion: store.state.paidVersionState.isPaid,
        authStatus: store.state.authState.status,
        dataStatus: store.state.dataState.status,
        cars: store.state.dataState.cars,
        onRefuelingAdded: (m, d, a, c, n) {
          store.dispatch(createRefueling(Refueling(
            odomSnapshot: OdomSnapshot(
                car: n, // TODO: return Car ID here
                mileage: store.state.unitsState.distance.unitToInternal(m),
                date: d),
            amount: store.state.unitsState.volume.unitToInternal(a),
            cost: store.state.unitsState.currency.unitToInternal(c),
          )));
        },
        onTodoAdded: (n, d, m, c, mR, dR) {
          store.dispatch(createTodo(Todo(
            name: n,
            dueDate: d,
            dueMileage: m,
            carId: c,
            mileageRepeatInterval: mR,
            dateRepeatInterval: dR,
          )));
        },
        onCarAdded: (name, odom, make, model, y, p, v) {
          store.dispatch(createCar(Car(
              name: name,
              // odomSnapshot: OdomSnapshot(mileage: odom, date: DateTime.now()),
              make: make,
              model: model,
              year: y,
              plate: p,
              vin: v)));
        });
  }
}
