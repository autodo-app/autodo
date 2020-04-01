
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
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
        topLeft: Radius.zero,
        topRight: Radius.zero),
      gradient: LinearGradient.lerp(grad1, grad2, 0.5));

  @override
  Widget build(BuildContext context) => Container(
    decoration: decoration,
    child: Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(25),),
        Text(
          "Jonathan's Garage",
          style: Theme.of(context).accentTextTheme.headline4),
        Padding(padding: EdgeInsets.all(5),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              color: Theme.of(context).accentTextTheme.button.color,
              onPressed: () {},
            ),
            Text(
              'PRO',
              style: Theme.of(context).accentTextTheme.button),
            IconButton(
              icon: Icon(Icons.settings),
              color: Theme.of(context).accentTextTheme.button.color,
              onPressed: () {},
            )
          ],
        ),
        Padding(padding: EdgeInsets.all(5),),
      ],
    )
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
      return Container(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: cars.map((c) => CarCard(c)).toList(),
          )
        )
      );
    }
  );
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
          color: Theme.of(context).accentTextTheme.button.color,),
        title: Text(
          JsonIntl.of(context).get(IntlKeys.findAMechanic),
          style: Theme.of(context).accentTextTheme.button
        ),
      ),
      onPressed: () {},
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
          color: Theme.of(context).accentTextTheme.button.color,),
        title: Text(
          JsonIntl.of(context).get(IntlKeys.learnToDiy),
          style: Theme.of(context).accentTextTheme.button
        ),
      ),
      onPressed: () {},
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
          color: Theme.of(context).accentTextTheme.button.color,),
        title: Text(
          JsonIntl.of(context).get(IntlKeys.findParts),
          style: Theme.of(context).accentTextTheme.button
        ),
      ),
      onPressed: () {},
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
          Padding(padding: EdgeInsets.all(5),),
          _CarGrid(),
          Padding(padding: EdgeInsets.all(5),),
          _MechanicButton(),
          Padding(padding: EdgeInsets.all(2),),
          _DiyButton(),
          Padding(padding: EdgeInsets.all(2),),
          _PartsButton(),
          Padding(padding: EdgeInsets.all(2),),
        ],
      ),
    );
  }
}