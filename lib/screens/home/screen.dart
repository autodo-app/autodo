import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'views/barrel.dart';

class HomeScreen extends StatefulWidget {
  final Key todosTabKey;
  final bool integrationTest;

  HomeScreen(
      {Key key = IntegrationTestKeys.homeScreen,
      this.todosTabKey,
      this.integrationTest = false})
      : super(key: key);

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(todosTabKey, integrationTest);
}

class _ScreenWithBanner extends StatelessWidget {
  final Widget child;
  final bool bannerShown;

  _ScreenWithBanner({this.child, this.bannerShown = true});

  @override
  build(context) => Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: child),
          ...((bannerShown)
              ? [Container(height: 50, color: Theme.of(context).cardColor)]
              : [])
        ],
      ));
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final Map<AppTab, Widget> views = {
    AppTab.todos: TodosScreen(),
    AppTab.refuelings: RefuelingsScreen(),
    AppTab.stats: StatisticsScreen(),
    AppTab.repeats: RepeatsScreen(),
  };
  final Key todosTabKey;
  final bool integrationTest;
  BannerAd _bannerAd;
  bool _bannerShown = false;

  // this has to be a function so that it returns a different route each time
  // the lifecycle of a MaterialPageRoute requires that it not be reused.
  List<MaterialPageRoute> Function() fabRoutes(cars) => () => [
        MaterialPageRoute(
          builder: (context) => _ScreenWithBanner(
            child: RefuelingAddEditScreen(
              isEditing: false,
              onSave: (m, d, a, c, n) {
                BlocProvider.of<RefuelingsBloc>(context)
                    .add(AddRefueling(Refueling(
                  mileage: m,
                  date: d,
                  amount: a,
                  cost: c,
                  carName: n,
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
                  onSave: (n, d, m, r, c) {
                    BlocProvider.of<TodosBloc>(context).add(AddTodo(Todo(
                        name: n,
                        dueDate: d,
                        dueMileage: m,
                        repeatName: r,
                        carName: c,
                        completed: false)));
                  },
                ))),
        MaterialPageRoute(
            builder: (context) => _ScreenWithBanner(
                    child: RepeatAddEditScreen(
                  isEditing: false,
                  onSave: (n, i, c) {
                    BlocProvider.of<RepeatsBloc>(context).add(AddRepeat(
                        Repeat(name: n, mileageInterval: i, cars: c)));
                  },
                ))),
      ];

  _HomeScreenState(this.todosTabKey, this.integrationTest);

  Widget get actionButton =>
      BlocBuilder<CarsBloc, CarsState>(builder: (context, state) {
        if (!(state is CarsLoaded)) {
          print('Cannot show fab without cars');
          return Container();
        } else if (integrationTest) {
          return AutodoActionButton(
              miniButtonRoutes: fabRoutes((state as CarsLoaded).cars),
              ticker: TestVSync());
        } else {
          return AutodoActionButton(
              miniButtonRoutes: fabRoutes((state as CarsLoaded).cars));
        }
      });

  _bannerAdConfig() => AutodoBannerAd(
        adUnitId: (kReleaseMode)
            ? 'ca-app-pub-6809809089648617/3864738913'
            : BannerAd.testAdUnitId,
        // listener: (event) {
        //   if (event == MobileAdEvent.loaded) {
        //     setState(() {
        //       _bannerShown = true;
        //     });
        //   } else if (event == MobileAdEvent.failedToLoad) {
        //     setState(() {
        //       _bannerShown = false;
        //     });
        // }}
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<PaidVersionBloc>(context)
        .observer
        .subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() async {
    // Route was pushed onto navigator and is now topmost route.
    if (ModalRoute.of(context).isCurrent) {
      print('didPush');
      _bannerShown = true;
      await _bannerAd?.dispose(); // clear old banner ad if one exists
      _bannerAd = _bannerAdConfig()
        ..load()
        ..show();
    }
  }

  @override
  void didPop() async {
    // Current route was popped off the navigator.
    print('didPop + $_bannerShown');
    if (_bannerShown) {
      _bannerShown = false;
      var res = await _bannerAd?.dispose(); // clear old banner ad if one exists
      print('result: $res');
    }
  }

  @override
  void didPushNext() async {
    // Another route is now above this route
    print('didPushNext + $_bannerShown + $_bannerAd');
    if (_bannerShown) {
      _bannerShown = false;
      var res = await _bannerAd?.dispose(); // clear old banner ad if one exists
      print('result: $res');
    }
    super.didPushNext();
  }

  @override
  initState() {
    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    super.initState();
  }

  List<Widget> fakeBottomButtons = [Container(height: 50)];

  @override
  build(context) =>
      BlocBuilder<PaidVersionBloc, PaidVersionState>(builder: (context, paid) {
        if (paid is PaidVersion && _bannerShown) {
          _bannerAd?.dispose()?.then((_) {
            setState(() {
              _bannerShown = false;
            });
          });
        }
        return BlocBuilder<TabBloc, AppTab>(
            builder: (context, activeTab) => _ScreenWithBanner(
                bannerShown: _bannerShown,
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(AutodoLocalizations.appTitle),
                      actions: [ExtraActions()],
                    ),
                    drawer: NavDrawer(),
                    body: views[activeTab],
                    floatingActionButton: actionButton,
                    bottomNavigationBar: TabSelector(
                      activeTab: activeTab,
                      onTabSelected: (tab) =>
                          BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
                      todosTabKey: todosTabKey,
                      refuelingsTabKey: ValueKey('__refuelings_tab_button__'),
                      repeatsTabKey: ValueKey('__repeats_tab_button__'),
                    ))));
      });
}
