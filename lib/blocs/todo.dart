import 'dart:async';

import 'package:autodo/items/items.dart';

class TodoBLoC {
  StreamController<MaintenanceTodoItem> ctrl;

  Function(MaintenanceTodoItem) get push => ctrl.sink.add;
  pushNew(String name, int mileage, DateTime date) {
    var item =
        MaintenanceTodoItem(name: name, dueDate: date, dueMileage: mileage);
    push(item);
  }

  Stream<MaintenanceTodoItem> get stream => ctrl.stream;

  // Make the object a Singleton
  static final TodoBLoC _bloc = new TodoBLoC._internal();
  factory TodoBLoC() {
    return _bloc;
  }
  TodoBLoC._internal() {
    ctrl = StreamController<MaintenanceTodoItem>.broadcast();
  }

  dispose() {
    ctrl.close();
  }
}

TodoBLoC todoBLoC = TodoBLoC();
