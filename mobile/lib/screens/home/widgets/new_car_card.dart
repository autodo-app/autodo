import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:json_intl/json_intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../../units/units.dart';
import '../../add_edit/barrel.dart';

class NewCarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) => GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CarAddEditScreen(
                        isEditing: false, onSave: vm.onCreateCar)));
          },
          child: Container(
            width: 140,
            height: 205,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Center(
              // This centering and its child are needed to prevent the edge of the
              // border from being cut off past 1px
              child: SizedBox(
                width:
                    130, // same goes for the sizes here, need to undersize the child to account for the border
                height: 205,
                child: DottedBorder(
                  color: Theme.of(context).buttonTheme.colorScheme.background,
                  padding: EdgeInsets.all(5),
                  strokeWidth: 4,
                  dashPattern: [15, 15],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(15),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          size: 48,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              .background,
                        ),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              JsonIntl.of(context).get(IntlKeys.addANewCar),
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .subtitle2
                                  .copyWith(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          .background),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel({@required this.onCreateCar});

  final Function(String, double, String, String, int, String, String)
      onCreateCar;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(onCreateCar: (name, odom, make, model, year, plate, vin) {
      store.dispatch(createCar(Car(
          name: name,
          snaps: [
            OdomSnapshot(
                mileage:
                    Distance.of(context, listen: false).unitToInternal(odom),
                date: DateTime.now()),
          ],
          make: make,
          model: model,
          year: year,
          plate: plate,
          vin: vin)));
    });
  }

  @override
  List get props => [onCreateCar];
}
