import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'package:autodo/localization.dart';
import 'package:intl/intl.dart';
import 'package:json_intl/json_intl.dart';

class _RefuelingTitle extends StatelessWidget {
  final Refueling refueling;

  _RefuelingTitle({Key key, @required this.refueling}) : super(key: key);

  dateField(context) => TextSpan(
      text: JsonIntl.of(context).get(IntlKeys.onLiteral) +
          ' ' + // TODO: Can't concat verb and date
          DateFormat.yMMMd().format(refueling.date) +
          ' ',
      style: Theme.of(context).primaryTextTheme.body1);

  @override
  build(context) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: JsonIntl.of(context).get(IntlKeys.refueling) + ' ',
                style: Theme.of(context).primaryTextTheme.body1),
            dateField(context),
            TextSpan(
                text: JsonIntl.of(context).get(IntlKeys.at) + ' ',
                style: Theme.of(context).primaryTextTheme.body1),
            TextSpan(
                text: NumberFormat.decimalPattern().format(refueling.mileage) +
                    ' ',
                style: Theme.of(context).primaryTextTheme.subtitle),
            TextSpan(
                text: JsonIntl.of(context).get(IntlKeys.distanceUnits),
                style: Theme.of(context).primaryTextTheme.body1)
          ],
        ),
      );
}

class _RefuelingCost extends StatelessWidget {
  final Refueling refueling;

  _RefuelingCost({Key key, @required this.refueling}) : super(key: key);

  @override
  build(context) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: JsonIntl.of(context).get(IntlKeys.totalCost) + ': ',
                style: Theme.of(context).primaryTextTheme.body1),
            TextSpan(
                text: NumberFormat.simpleCurrency(name: 'USD')
                    .format(refueling.cost), // TODO: check unit
                style: Theme.of(context).primaryTextTheme.subtitle),
          ],
        ),
      );
}

class _RefuelingAmount extends StatelessWidget {
  final Refueling refueling;

  _RefuelingAmount({Key key, @required this.refueling}) : super(key: key);

  @override
  build(context) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: JsonIntl.of(context).get(IntlKeys.totalAmount) + ': ',
                style: Theme.of(context).primaryTextTheme.body1),
            TextSpan(
                text: NumberFormat(',###.0#').format(refueling.amount),
                style: Theme.of(context).primaryTextTheme.subtitle),
            TextSpan(
                text: ' ' + JsonIntl.of(context).get(IntlKeys.fuelUnits),
                style: Theme.of(context).primaryTextTheme.body1)
          ],
        ),
      );
}

class _RefuelingBody extends StatelessWidget {
  final Refueling refueling;

  _RefuelingBody({Key key, @required this.refueling}) : super(key: key);

  @override
  build(context) => Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _RefuelingCost(refueling: refueling),
          _RefuelingAmount(refueling: refueling),
        ],
      ));
}

class _RefuelingTags extends StatelessWidget {
  final Refueling refueling;

  _RefuelingTags({Key key, @required this.refueling}) : super(key: key);

  @override
  build(context) => CarTag(text: refueling.carName, color: refueling.carColor);
}

class _RefuelingEditButton extends StatelessWidget {
  final Refueling refueling;

  _RefuelingEditButton({Key key, @required this.refueling}) : super(key: key);

  @override
  build(context) => ButtonTheme.fromButtonThemeData(
        data: ButtonThemeData(
          minWidth: 0,
        ),
        child: FlatButton(
          key: ValueKey(
              '__refueling_card_edit_${refueling.carName}_${refueling.mileage}'),
          child: const Icon(Icons.edit),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RefuelingAddEditScreen(
                // this below is an assumption, not the safest option
                cars: (BlocProvider.of<CarsBloc>(context).state as CarsLoaded)
                    .cars,
                refueling: refueling,
                isEditing: true,
                onSave: (m, d, a, c, n) {
                  BlocProvider.of<RefuelingsBloc>(context)
                      .add(UpdateRefueling(refueling.copyWith(
                    mileage: m,
                    date: d,
                    amount: a,
                    cost: c,
                    carName: n,
                  )));
                },
              ),
            ),
          ),
        ),
      );
}

class _RefuelingDeleteButton extends StatelessWidget {
  final Refueling refueling;

  _RefuelingDeleteButton({Key key, @required this.refueling}) : super(key: key);

  @override
  build(context) => ButtonTheme.fromButtonThemeData(
        data: ButtonThemeData(
          minWidth: 0,
        ),
        child: FlatButton(
          key: ValueKey(
              '__refueling_delete_button_${refueling.carName}_${refueling.mileage}'),
          child: const Icon(Icons.delete),
          onPressed: () {
            BlocProvider.of<RefuelingsBloc>(context)
                .add(DeleteRefueling(refueling));
            Scaffold.of(context).showSnackBar(DeleteRefuelingSnackBar(
              onUndo: () => BlocProvider.of<RefuelingsBloc>(context)
                  .add(AddRefueling(refueling)),
            ));
          },
        ),
      );
}

class _RefuelingFooter extends StatelessWidget {
  final Refueling refueling;

  _RefuelingFooter({Key key, @required this.refueling}) : super(key: key);

  @override
  build(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _RefuelingTags(refueling: refueling),
          Row(
            children: <Widget>[
              _RefuelingEditButton(refueling: refueling),
              _RefuelingDeleteButton(refueling: refueling),
            ],
          ),
        ],
      );
}

class RefuelingCard extends StatelessWidget {
  final Refueling refueling;
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;

  RefuelingCard(
      {Key key,
      @required this.refueling,
      @required this.onDismissed,
      @required this.onTap})
      : super(key: key);

  @override
  build(context) => InkWell(
      onTap: onTap,
      child: Dismissible(
          key: Key("__dismissible__"),
          onDismissed: onDismissed,
          child: Card(
            elevation: 4,
            color: Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: _RefuelingTitle(refueling: refueling),
                    ),
                    Divider(),
                  ],
                ),
                _RefuelingBody(refueling: refueling),
                _RefuelingFooter(refueling: refueling),
              ],
            ),
          )));
}
