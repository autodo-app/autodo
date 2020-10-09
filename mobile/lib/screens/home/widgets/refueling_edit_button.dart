import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../../units/units.dart';
import '../../add_edit/barrel.dart';

class RefuelingEditButton extends StatelessWidget {
  const RefuelingEditButton({Key key, @required this.refueling})
      : super(key: key);

  final Refueling refueling;

  @override
  Widget build(BuildContext context) => StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) =>
            ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
          ),
          child: FlatButton(
            key: ValueKey(
                '__refueling_card_edit_${refueling.odomSnapshot.date}'),
            child: Icon(
              Icons.edit,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RefuelingAddEditScreen(
                            isEditing: true,
                            refueling: refueling,
                            onSave: (m, d, a, c, n) =>
                                vm.onUpdateRefueling(refueling, m, d, a, c, n),
                            cars: vm.cars,
                          )));
            },
          ),
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel({@required this.onUpdateRefueling, @required this.cars});

  final Function(Refueling, double, DateTime, double, double, String)
      onUpdateRefueling;
  final List<Car> cars;

  static _ViewModel fromStore(Store<AppState> store) {
    if (store.state.dataState.status == DataStatus.IDLE) {
      store.dispatch(fetchData());
    }
    return _ViewModel(
        onUpdateRefueling: (refueling, m, d, a, c, n) {
          store.dispatch(updateRefueling(refueling.copyWith(
            odomSnapshot: OdomSnapshot(
              car: n,
              mileage: Distance.of(context, listen: false).unitToInternal(m),
              date: d,
            ),
            amount: Volume.of(context, listen: false).unitToInternal(a),
            cost: Currency.of(context, listen: false).unitToInternal(c),
          )));
        },
        cars: store.state.dataState.cars);
  }

  @override
  List get props => [];
}
