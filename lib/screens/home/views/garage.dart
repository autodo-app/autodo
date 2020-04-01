
/// Garage Screen showing the user's vehicles, parts, and some maintenance tips.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../theme.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';

class _Header extends StatelessWidget {
  static final grad1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [mainColors[300], mainColors[400]]);

  static final grad2 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [mainColors[700], mainColors[900]]);

  final BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      gradient: LinearGradient.lerp(grad1, grad2, 0.5));

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25))),
    child: Container(
      decoration: decoration,
      child: Column(
        children: <Widget>[
          Text("Jonathan's Garage"),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {},
              ),
              Text('PRO'),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              )
            ],
          )
        ],
      )
    ),
  );
}

class _CarGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<CarsBloc, CarsState>(
    builder: (context, state) {
      if (!(state is CarsLoaded)) {
        return LoadingIndicator();
      }
      final cars = (state as CarsLoaded).cars;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: cars.map((c) => CarCard(c)).toList(),
        )
      );
    }
  );
}

class _MechanicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25)
      )
    ),
    color: Theme.of(context).primaryColor,
    child: ListTile(
      leading: Icon(Icons.search),
      title: Text(
        JsonIntl.of(context).get(IntlKeys.findAMechanic),
        style: Theme.of(context).accentTextTheme.button
      ),
    ),
    onPressed: () {},
  );
}

class _DiyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25)
      )
    ),
    color: Theme.of(context).cardColor,
    child: ListTile(
      leading: Icon(Icons.build),
      title: Text(
        JsonIntl.of(context).get(IntlKeys.learnToDiy),
        style: Theme.of(context).primaryTextTheme.button
      ),
    ),
    onPressed: () {},
  );
}

class _PartsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25)
      )
    ),
    color: Theme.of(context).cardColor,
    child: ListTile(
      leading: Icon(Icons.build),
      title: Text(
        JsonIntl.of(context).get(IntlKeys.findParts),
        style: Theme.of(context).primaryTextTheme.button
      ),
    ),
    onPressed: () {},
  );
}

class GarageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _Header(),
          _CarGrid(),
          _MechanicButton(),
          _DiyButton(),
          _PartsButton(),
        ],
      ),
    );
  }
}