import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';

class CarsBLoC extends BLoC {
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

  static final CarsBLoC _self = CarsBLoC._internal();
  factory CarsBLoC() {
    return _self;
  }
  CarsBLoC._internal();
}