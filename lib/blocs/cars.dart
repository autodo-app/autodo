import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';

class CarsBLoC extends BLoC {
  static const double EMA_GAIN = 0.9;
  static const double EMA_CUTOFF = 8;
  // don't know why anyone would enter this many, but preventing overflow here
  static const int MAX_NUM_REFUELINGS = 0xffff;

  Future<void> push(Car item) async {
    pushItem('cars', item);
  }

  void edit(Car item) {
    editItem('cars', item);
  }

  void delete(Car item) {
    deleteItem('cars', item);
  }

  void undo() {
    undoItem('cars');
  }

  Future<Car> getCarByName(String name) async {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    QuerySnapshot cars = await userDoc
      .collection('cars')
      .getDocuments();
    for (var doc in cars.documents) {
      if (doc.data['name'] == name)
        return Car.fromJSON(doc.data, doc.documentID);
    }
    return null;
  }

  Future<List<Car>> getCars() async {
    List<Car> out = []; // assign it so that .add() works
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    QuerySnapshot cars = await userDoc
      .collection('cars')
      .getDocuments();
    cars.documents.forEach((car) {
      out.add(Car.fromJSON(car.data, car.documentID));
    });
    return out;
  }

  Future<void> updateMileage(String carName, int mileage) async {
    Car car = await getCarByName(carName);
    if (car == null || car.mileage > mileage)
      return; // allow adding past refuelings, but odometers don't go backwards
    car.mileage = mileage;
    edit(car);
  }

  double filter(int numRefuelings, double prev, double cur) {
    if (numRefuelings > EMA_CUTOFF) {
      return EMA_GAIN * prev + (1 - EMA_GAIN) * cur;
    } else {
      double fac1 = (numRefuelings - 1) / numRefuelings;
      double fac2 = 1 / numRefuelings;
      return prev * fac1 + cur * fac2;
    }
  }

  Future<void> updateEfficiency(String carName, double eff) async {
    Car car = await getCarByName(carName);
    if (car == null) return;

    if (car.numRefuelings < MAX_NUM_REFUELINGS)
      car.numRefuelings++;
    if (car.numRefuelings == 1) {
      // first refueling for this car
      car.averageEfficiency = eff;
    } else {
      car.averageEfficiency = filter(car.numRefuelings, car.averageEfficiency, eff);
    }
    edit(car);
  }

  static final CarsBLoC _self = CarsBLoC._internal();
  factory CarsBLoC() {
    return _self;
  }
  CarsBLoC._internal();
}