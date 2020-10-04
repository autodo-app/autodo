import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'odom_snapshot.dart';

class Car extends Equatable {
  const Car(
      {this.id,
      @required this.name,
      this.make,
      this.model,
      this.year,
      this.plate,
      this.vin,
      this.imageName,
      this.color,
      this.odom,
      this.snaps});

  factory Car.fromMap(String id, Map<String, dynamic> value) => Car(
        id: id,
        name: value['name'] as String,
        make: value['make'] as String,
        model: value['model'] as String,
        year: value['year'] as int,
        plate: value['plate'] as String,
        vin: value['vin'] as String,
        imageName: value['imageName'] as String,
        color: value['color'] as int,
        odom: value['odom'] as int,
        snaps: value['snaps'].map((s) => OdomSnapshot.fromMap(s['id'], s)),
      );

  /// The UID for the Car object on the server.
  final String id;

  /// An arbitrary user-defined name used to identify the Car in the UI.
  final String name;

  /// The Manufacturer of the Car.
  final String make;

  /// The model name of the Car.
  final String model;

  /// The model year of the Car.
  final int year;

  /// The license plate number of the Car.
  final String plate;

  /// The official identification number for the Car.
  final String vin;

  /// The URI for an image of the Car.
  final String imageName;

  /// The hex code for a color identifying the Car in the UI.
  final int color;

  /// The last recorded odometer reading for the Car.
  /// Note: this field is read-only.
  final int odom;

  /// The full list of recorded odometer reading for the Car.
  final List<OdomSnapshot> snaps;

  Car copyWith(
          {String id,
          String name,
          String make,
          String model,
          int year,
          String plate,
          String vin,
          String imageName,
          int color,
          int odom,
          List<OdomSnapshot> snaps}) =>
      Car(
          id: id ?? this.id,
          name: name ?? this.name,
          make: make ?? this.make,
          model: model ?? this.model,
          year: year ?? year,
          plate: plate ?? plate,
          vin: vin ?? vin,
          imageName: imageName ?? this.imageName,
          color: color ?? this.color,
          odom: odom ?? this.odom,
          snaps: snaps ?? this.snaps);

  Map<String, dynamic> toDocument() => {
        'name': name,
        'make': make,
        'model': model,
        'year': year.toString(),
        'plate': plate,
        'vin': vin,
        'imageName': imageName,
        'color': color.toString(),
        'snaps': snaps.map((s) => s.toDocument()).toList(),
      };

  @override
  List<Object> get props =>
      [id, name, make, model, year, plate, vin, imageName, color, odom, snaps];
}
