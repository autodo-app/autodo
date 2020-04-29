import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../../units/units.dart';
import '../../add_edit/barrel.dart';

class RefuelingEditButton extends StatelessWidget {
  const RefuelingEditButton({Key key, @required this.refueling})
      : super(key: key);

  final Refueling refueling;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CarsBloc, CarsState>(builder: (context, state) {
        if (!(state is CarsLoaded)) {
          return Container();
        }

        return ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
          ),
          child: FlatButton(
            key: ValueKey('__refueling_card_edit_${refueling.date}'),
            child: Icon(
              Icons.edit,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RefuelingAddEditScreen(
                            isEditing: false,
                            onSave: (m, d, a, c, n) {
                              BlocProvider.of<RefuelingsBloc>(context)
                                  .add(AddRefueling(Refueling(
                                mileage: Distance.of(context, listen: false)
                                    .unitToInternal(m),
                                date: d,
                                amount: Volume.of(context, listen: false)
                                    .unitToInternal(a),
                                cost: Currency.of(context, listen: false)
                                    .unitToInternal(c),
                                carName: n,
                              )));
                            },
                            cars: (state as CarsLoaded).cars,
                          )));
            },
          ),
        );
      });
}
