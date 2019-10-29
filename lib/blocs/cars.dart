import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/firestore.dart';

class CarsBLoC {
  Car _past;

  Future<void> push(Car car) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = await userDoc
      .collection('cars')
      .add(car.toJSON());
    if (ref == null) {
      print('Cars BLoC: push failed');
      return;
    }
    car.ref = ref.documentID;
    ref.setData(car.toJSON());
  }

  Future<void> edit(Car car) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = userDoc
      .collection('cars')
      .document(car.ref);
    if (ref == null) {
      print('Cars BLoC: edit failed');
      return;
    }
    ref.updateData(car.toJSON());
  }

  Future<void> delete(Car car) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = userDoc
      .collection('cars')
      .document(car.ref);
    if (ref == null) {
      print('Cars BLoC: delete failed');
      return;
    }
    _past = car;
    ref.delete();
  }

  void undo() {
    if (_past != null) push(_past);
    _past = null;
  }

  Future<Car> getCarByName(String name) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
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
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    QuerySnapshot cars = await userDoc
      .collection('cars')
      .getDocuments();
    cars.documents.forEach((car) {
      out.add(Car.fromJSON(car.data, car.documentID));
    });
    return out;
  }

  int currentCarMileage = 0;
  Map<String, int> lastCompletedRepeatTodos;

  void setCurrentMileage(int update){
    currentCarMileage = update;
  }

  int getCurrentMileage() {
    return currentCarMileage;
  }

  void setLastCompleted(String key, int val) {
    lastCompletedRepeatTodos[key] = val;
  }

  static final CarsBLoC _self = CarsBLoC._internal();
  factory CarsBLoC() {
    return _self;
  }
  CarsBLoC._internal();
}