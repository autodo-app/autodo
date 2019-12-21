import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/widgets/barrel.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/blocs/refuelings/barrel.dart';
import 'package:autodo/screens/details/barrel.dart';
import 'package:autodo/blocs/filtered_refuelings/barrel.dart';
import 'package:autodo/screens/add_edit/barrel.dart';

class _RefuelingTitle extends StatelessWidget {
  final Refueling refueling;

  _RefuelingTitle({Key key, @required this.refueling})
      : super(key: key);

  dateField(context) {
    if (refueling.date != null) {
      return TextSpan(  
        text: AutodoLocalizations.onLiteral + ' ' + AutodoLocalizations.dateFormat(refueling.date) + ' ',
        style: Theme.of(context).primaryTextTheme.body1
      );
    } else {
      return Container();
    }
  }

  @override 
  build(context) => RichText(  
    text: TextSpan(  
      children: [
        TextSpan(
          text: AutodoLocalizations.refueling + ' ',
          style: Theme.of(context).primaryTextTheme.body1
        ),
        dateField(context),
        TextSpan(  
          text: AutodoLocalizations.at + ' ',
          style: Theme.of(context).primaryTextTheme.body1
        ),
        TextSpan(
          text: refueling.mileage.toString() + ' ',
          style: Theme.of(context).primaryTextTheme.subtitle
        ),
        TextSpan(  
          text: AutodoLocalizations.distanceUnits,
          style: Theme.of(context).primaryTextTheme.body1
        )
      ],
    ),
  );
}

class _RefuelingCost extends StatelessWidget {
  final Refueling refueling;

  _RefuelingCost({Key key, @required this.refueling})
      : super(key: key);

  @override 
  build(context) => RichText(  
    text: TextSpan(  
      children: [
        TextSpan(  
          text: AutodoLocalizations.totalCost + ': ',
          style: Theme.of(context).primaryTextTheme.body1
        ),
        TextSpan(  
          text: AutodoLocalizations.moneyUnits + refueling.cost.toStringAsFixed(2),
          style: Theme.of(context).primaryTextTheme.subtitle
        ),
      ],
    ),
  );
}

class _RefuelingAmount extends StatelessWidget {
  final Refueling refueling;

  _RefuelingAmount({Key key, @required this.refueling})
      : super(key: key);

  @override 
  build(context) => RichText(  
    text: TextSpan(  
      children: [
        TextSpan(  
          text: AutodoLocalizations.totalAmount + ': ',
          style: Theme.of(context).primaryTextTheme.body1
        ),
        TextSpan(  
          text: refueling.amount.toStringAsFixed(2),
          style: Theme.of(context).primaryTextTheme.subtitle
        ),
        TextSpan(  
          text: ' ' + AutodoLocalizations.fuelUnits,
          style: Theme.of(context).primaryTextTheme.body1
        )
      ],
    ),
  );
}

class _RefuelingBody extends StatelessWidget {
  final Refueling refueling;

  _RefuelingBody({Key key, @required this.refueling})
      : super(key: key);

  @override 
  build(context) => Container(  
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: Column(  
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _RefuelingCost(refueling: refueling),
        _RefuelingAmount(refueling: refueling),
      ],
    )
  );
}

class _RefuelingTags extends StatelessWidget {
  final Refueling refueling;

  _RefuelingTags({Key key, @required this.refueling})
      : super(key: key);

  @override 
  build(context) => CarTag(text: refueling.carName, color: refueling.carColor);
}

class _RefuelingEditButton extends StatelessWidget {
  final Refueling refueling;

  _RefuelingEditButton({Key key, @required this.refueling})
      : super(key: key);

  @override 
  build(context) => ButtonTheme.fromButtonThemeData(
    data: ButtonThemeData(
      minWidth: 0,
    ),
    child: FlatButton(
      child: const Icon(Icons.edit),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RefuelingAddEditScreen(
            refueling: refueling,
            isEditing: true,
            onSave: (m, d, a, c, n) {
              BlocProvider.of<RefuelingsBloc>(context).add(  
                UpdateRefueling(refueling.copyWith(
                  mileage: m,
                  date: d,
                  amount: a,
                  cost: c,
                  carName: n,
                ))
              );
            },
          ),
        ),
      ),
    ),
  );
}

class _RefuelingDeleteButton extends StatelessWidget {
  final Refueling refueling;

  _RefuelingDeleteButton({Key key, @required this.refueling})
      : super(key: key);

  @override 
  build(context) => ButtonTheme.fromButtonThemeData(
    data: ButtonThemeData(
      minWidth: 0,
    ),
    child: FlatButton(
      child: const Icon(Icons.delete),
      onPressed: () {
        BlocProvider.of<RefuelingsBloc>(context).add(
          DeleteRefueling(refueling)
        );
        Scaffold.of(context).showSnackBar(
          DeleteRefuelingSnackBar(
            onUndo: () => BlocProvider.of<RefuelingsBloc>(context)
              .add(AddRefueling(refueling)),
          )
        );
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

class _RefuelingCard extends StatelessWidget {
  final Refueling refueling;
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;

  _RefuelingCard({
    Key key,
    @required this.refueling,
    @required this.onDismissed,
    @required this.onTap
  }) : super(key: key);

  @override 
  build(context) => Dismissible(  
    key: Key("__dismissible__"),
    onDismissed: onDismissed,
    child: Card(  
      elevation: 4,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    )
  );
}

class RefuelingsScreen extends StatelessWidget {
  RefuelingsScreen({Key key}) : super(key: key);

  onDismissed(direction, context, refueling) {
    BlocProvider.of<RefuelingsBloc>(context).add(DeleteRefueling(refueling));
    Scaffold.of(context).showSnackBar(
      DeleteRefuelingSnackBar(
        onUndo: () => BlocProvider.of<RefuelingsBloc>(context)
          .add(AddRefueling(refueling)),
      )
    );
  }

  onTap(context, refueling) async {
    final removedRefueling = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailsScreen(id: refueling.id),
      ),
    );
    if (removedRefueling != null) {
      Scaffold.of(context).showSnackBar(
      DeleteRefuelingSnackBar(
        onUndo: () => BlocProvider.of<RefuelingsBloc>(context)
          .add(AddRefueling(refueling)),
      )
    );
    }
  }

  @override 
  build(context) => 
      BlocBuilder<FilteredRefuelingsBloc, FilteredRefuelingsState>(  
    builder: (context, state) {
      if (state is FilteredRefuelingsLoading) {
        return LoadingIndicator();
      } else if (state is FilteredRefuelingsLoaded) {
        final refuelings = state.filteredRefuelings;
        return ListView.builder(   
          itemCount: refuelings.length,
          itemBuilder: (context, index) {
            final refueling = refuelings[index];
            return Padding(  
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: _RefuelingCard(  
                refueling: refueling,
                onDismissed: (direction) =>
                    onDismissed(direction, context, refueling),
                onTap: () => onTap(context, refueling)
              ),          
            );
          }
        );
      } else {
        return Container();
      }
    }
  );
}