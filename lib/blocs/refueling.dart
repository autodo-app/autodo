import 'dart:async';

import 'package:autodo/items/items.dart';

class RefuelingBLoC {
  StreamController<RefuelingItem> ctrl;

  Function(RefuelingItem) get push => ctrl.sink.add;
  // pushNew(String name, int mileage, DateTime date) {
  //   var item = RefuelingItem(name: name, dueDate: date, dueMileage: mileage);
  //   push(item);
  // }

  Stream<RefuelingItem> get stream => ctrl.stream;

  // Make the object a Singleton
  static final RefuelingBLoC _bloc = new RefuelingBLoC._internal();
  factory RefuelingBLoC() {
    return _bloc;
  }
  RefuelingBLoC._internal() {
    ctrl = StreamController<RefuelingItem>.broadcast();
  }

  dispose() {
    ctrl.close();
  }
}

RefuelingBLoC refuelingBLoC = RefuelingBLoC();
