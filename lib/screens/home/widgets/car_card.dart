import 'package:flutter/material.dart';

import '../../../models/models.dart';

class CarCard extends StatelessWidget {
  const CarCard(this.car);

  final Car car;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(5),
    child: Container(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: <Widget>[
            // Image.asset('car1.jpg'),
            Padding(padding: EdgeInsets.all(5),),
            Center(
              child: Text(
                '2015 Sonic',
                style: Theme.of(context).primaryTextTheme.headline6),
            ),
            Padding(padding: EdgeInsets.all(5),),
            Center(
              child: Text(
                'Plate: 23908u4',
                style: Theme.of(context).primaryTextTheme.bodyText2)
            ),
            Center(
              child: Text('Odom: safdlkj',
                style: Theme.of(context).primaryTextTheme.bodyText2)
            ),
            Padding(padding: EdgeInsets.all(5),),
            Icon(Icons.zoom_in),
            Padding(padding: EdgeInsets.all(5),),
          ],
        ),
      ),
    ),
  );
}