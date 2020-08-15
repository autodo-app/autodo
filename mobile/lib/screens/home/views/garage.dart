/// Garage Screen showing the user's vehicles, parts, and some maintenance tips.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../flavor.dart';
import '../../../generated/localization.dart';
import '../../../screens/settings/screen.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';

class _PaidVersionStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!kFlavor.hasPaid) {
      return Container();
    }
    return BlocBuilder<PaidVersionBloc, PaidVersionState>(
        builder: (context, state) {
      if (state is PaidVersion) {
        return Text(JsonIntl.of(context).get(IntlKeys.proCaps),
            style: Theme.of(context).accentTextTheme.button);
      } else {
        return FlatButton(
          key: ValueKey('__upgrade_drawer_button__'),
          child: Text(JsonIntl.of(context).get(IntlKeys.upgradeCaps),
              style: Theme.of(context).accentTextTheme.button),
          onPressed: () => showDialog(
              context: context,
              child: UpgradeDialog(
                context: context,
                trialUser: BlocProvider.of<AuthenticationBloc>(context).state
                    is LocalAuthenticated,
              )),
        );
      }
    });
  }
}

class _Header extends StatelessWidget {
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
              _PaidVersionStatus(),
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
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        if (!(state is DataLoaded)) {
          return LoadingIndicator();
        }
        final cars = (state as DataLoaded).cars;
        return Container(
            padding: EdgeInsets.all(5),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: cars.map<Widget>((c) => CarCard(c)).toList()
                    ..add(NewCarCard()),
                )));
      });
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _Header(),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          _CarGrid(),
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
    );
  }
}
