
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../models/models.dart';
import '../../add_edit/barrel.dart';

class CarCard extends StatelessWidget {
  const CarCard(this.car);

  final Car car;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(5),
    child: GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CarAddEditScreen(
            car: car,
            isEditing: false,
          )
        ));
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
                tag: car.name,
                child: FutureBuilder(
                  future: car.getImageDownloadUrl(),
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator();
                    }
                    return CachedNetworkImage(
                      fit: BoxFit.fill,
                      height: 80,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: snap.data,
                    );
                  }
                ),
              ),
              Padding(padding: EdgeInsets.all(5),),
              Center(
                child: Text(
                  '2015 Sonic',
                  style: Theme.of(context).primaryTextTheme.headline6),
              ),
              Center(
                child: Text(
                  'Plate: 23908u4',
                  style: Theme.of(context).primaryTextTheme.bodyText2)
              ),
              Center(
                child: Text('Odom: safdlkj',
                  style: Theme.of(context).primaryTextTheme.bodyText2)
              ),
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