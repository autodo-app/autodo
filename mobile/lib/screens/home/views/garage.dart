import 'package:equatable/equatable.dart';

/// Garage Screen showing the user's vehicles, parts, and some maintenance tips.
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../flavor.dart';
import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../../screens/settings/screen.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';

class _PaidVersionStatus extends StatelessWidget {
  const _PaidVersionStatus(this.isPaid);

  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    if (!kFlavor.hasPaid) {
      return Container();
    } else if (isPaid) {
      return Text(JsonIntl.of(context).get(IntlKeys.proCaps),
          style: Theme.of(context).accentTextTheme.button);
    } else {
      return FlatButton(
        key: ValueKey('__upgrade_drawer_button__'),
        child: Text(JsonIntl.of(context).get(IntlKeys.upgradeCaps),
            style: Theme.of(context).accentTextTheme.button),
        onPressed: () => showDialog(
            context: context,
            child: UpgradeDialog(context: context, trialUser: false)),
      );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header(this.isPaid);

  final bool isPaid;

  @override
  Widget build(BuildContext context) => Container(
      decoration: headerDecoration.copyWith(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(25),
          ),
          Text(JsonIntl.of(context).get(IntlKeys.myGarage),
              style: Theme.of(context).accentTextTheme.headline1),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle),
                color: Theme.of(context).accentTextTheme.button.color,
                onPressed: () {
                  // TODO: create some sort of account screen here?
                  showDialog(
                      context: context,
                      child: AlertDialog(
                          title: Text(JsonIntl.of(context)
                              .get(IntlKeys.toBeImplemented))));
                },
              ),
              _PaidVersionStatus(isPaid),
              IconButton(
                icon: Icon(Icons.settings),
                color: Theme.of(context).accentTextTheme.button.color,
                onPressed: () => SettingsScreen.show(context),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
        ],
      ));
}

class _CarGrid extends StatelessWidget {
  const _CarGrid(this.cars);

  final List<Car> cars;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(5),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: cars.map<Widget>((c) => CarCard(c)).toList()
              ..add(NewCarCard()),
          )));
}

class _MechanicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        child: RaisedButton(
          elevation: 5.0,
          shape: Theme.of(context).buttonTheme.shape,
          color: Theme.of(context).primaryColor,
          child: ListTile(
            leading: Icon(
              Icons.search,
              color: Theme.of(context).accentTextTheme.button.color,
            ),
            title: Text(JsonIntl.of(context).get(IntlKeys.findAMechanic),
                style: Theme.of(context).accentTextTheme.button),
          ),
          onPressed: () {
            showDialog(
                context: context,
                child: AlertDialog(
                    title: Text(
                        JsonIntl.of(context).get(IntlKeys.toBeImplemented))));
          },
        ),
      );
}

class _DiyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        child: RaisedButton(
          elevation: 5.0,
          shape: Theme.of(context).buttonTheme.shape,
          color: Theme.of(context).buttonTheme.colorScheme.background,
          child: ListTile(
            leading: Icon(
              Icons.build,
              color: Theme.of(context).accentTextTheme.button.color,
            ),
            title: Text(JsonIntl.of(context).get(IntlKeys.learnToDiy),
                style: Theme.of(context).accentTextTheme.button),
          ),
          onPressed: () {
            showDialog(
                context: context,
                child: AlertDialog(
                    title: Text(
                        JsonIntl.of(context).get(IntlKeys.toBeImplemented))));
          },
        ),
      );
}

class _PartsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        child: RaisedButton(
          elevation: 5.0,
          shape: Theme.of(context).buttonTheme.shape,
          color: Theme.of(context).buttonTheme.colorScheme.background,
          child: ListTile(
            leading: Icon(
              Icons.build,
              color: Theme.of(context).accentTextTheme.button.color,
            ),
            title: Text(JsonIntl.of(context).get(IntlKeys.findParts),
                style: Theme.of(context).accentTextTheme.button),
          ),
          onPressed: () {
            showDialog(
                context: context,
                child: AlertDialog(
                    title: Text(
                        JsonIntl.of(context).get(IntlKeys.toBeImplemented))));
          },
        ),
      );
}

class GarageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (context, vm) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _Header(vm.isPaid),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              _CarGrid(vm.cars),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              _MechanicButton(),
              Padding(
                padding: EdgeInsets.all(2),
              ),
              _DiyButton(),
              Padding(
                padding: EdgeInsets.all(2),
              ),
              _PartsButton(),
              Padding(
                padding: EdgeInsets.all(2),
              ),
            ],
          ),
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel({@required this.cars, @required this.isPaid});

  final List<Car> cars;
  final bool isPaid;

  static _ViewModel fromStore(Store<AppState> store) {
    if (store.state.dataState.status == DataStatus.IDLE) {
      store.dispatch(fetchData());
    }
    if (store.state.paidVersionState.status == PaidVersionStatus.IDLE) {
      store.dispatch(fetchPaidVersionStatus());
    }
    return _ViewModel(
        cars: store.state.dataState.cars,
        isPaid: store.state.paidVersionState.isPaid);
  }

  @override
  List get props => [...cars];
}
