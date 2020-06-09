import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../units/units.dart';
import '../../add_edit/barrel.dart';

class CarCard extends StatelessWidget {
  const CarCard(this.car);

  final Car car;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CarAddEditScreen(
                          car: car,
                          isEditing: false,
                          onSave: (name, odom, make, model, year, plate, vin) {
                            BlocProvider.of<DataBloc>(context).add(UpdateCar(
                                car.copyWith(
                                    name: name,
                                    odomSnapshot: OdomSnapshot(
                                      car: car.id,
                                      mileage: Distance.of(context, listen: false).unitToInternal(odom),
                                      date: DateTime.now()
                                    ),
                                    make: make,
                                    model: model,
                                    year: year,
                                    plate: plate,
                                    vin: vin)));
                          },
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
                        future: (BlocProvider.of<DatabaseBloc>(context).state
                                as DbLoaded)
                            .storageRepo
                            ?.getDownloadUrl(car.imageName),
                        builder: (context, snap) {
                          if (snap.connectionState != ConnectionState.done) {
                            return SizedBox(height: 80);
                          }
                          return CachedNetworkImage(
                            fit: BoxFit.fill,
                            height: 80,
                            placeholder: (context, url) => SizedBox(height: 80),
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
                          style: Theme.of(context).primaryTextTheme.bodyText2)),
                  Center(
                      child: Text(
                          '${JsonIntl.of(context).get(IntlKeys.odom)}: ${Distance.of(context).format(car.odomSnapshot.mileage)}',
                          style: Theme.of(context).primaryTextTheme.bodyText2)),
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
      );
}
