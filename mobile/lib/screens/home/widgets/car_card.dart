import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:json_intl/json_intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../../units/units.dart';
import '../../add_edit/barrel.dart';

class CarCard extends StatelessWidget {
  const CarCard(this.car);

  final Car car;

  @override
  Widget build(BuildContext context) => StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) => Container(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CarAddEditScreen(
                            car: car,
                            isEditing: false,
                            onSave:
                                (name, odom, make, model, year, plate, vin) =>
                                    vm.onUpdateCar(car, name, odom, make, model,
                                        year, plate, vin),
                          )));
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: SizedBox(
                width: 140,
                height: 205,
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: car.id,
                      child: FutureBuilder(
                          future: vm.getDownloadUrl(car),
                          builder: (context, snap) {
                            if (snap.connectionState != ConnectionState.done) {
                              return SizedBox(height: 80);
                            }
                            return CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 80,
                              placeholder: (context, url) =>
                                  SizedBox(height: 80),
                              errorWidget: (context, url, error) => SizedBox(
                                height: 80,
                                child: Icon(Icons.directions_car, size: 40),
                              ),
                              imageUrl: snap.data,
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Center(
                      child: Text(car.name,
                          style: Theme.of(context).primaryTextTheme.headline6),
                    ),
                    Center(
                        child: Text(
                            '${JsonIntl.of(context).get(IntlKeys.plate)}: ${car.plate}',
                            style:
                                Theme.of(context).primaryTextTheme.bodyText2)),
                    Center(
                        child: Text(
                            '${JsonIntl.of(context).get(IntlKeys.odom)}: ${Distance.of(context).format(car.odom)}',
                            style:
                                Theme.of(context).primaryTextTheme.bodyText2)),
                    // Padding(padding: EdgeInsets.all(5),),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.zoom_in))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel({@required this.onUpdateCar, @required this.getDownloadUrl});

  final Function(Car, String, double, String, String, int, String, String)
      onUpdateCar;
  final Function(Car) getDownloadUrl;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        onUpdateCar: (car, name, odom, make, model, year, plate, vin) {
          store.dispatch(updateCar(car.copyWith(
              name: name,
              snaps: [
                OdomSnapshot(
                    car: car.id,
                    mileage:
                        store.state.unitsState.distance.unitToInternal(odom),
                    date: DateTime.now()),
              ],
              make: make,
              model: model,
              year: year,
              plate: plate,
              vin: vin)));
        },
        getDownloadUrl: (car) =>
            store.state.api.imageDownloadUrl(car.id, car.imageName));
  }

  @override
  List get props => [onUpdateCar];
}
