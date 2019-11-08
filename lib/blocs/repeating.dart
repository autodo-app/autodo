import 'dart:async';

import 'package:autodo/blocs/todo.dart';
import 'package:autodo/blocs/cars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/subcomponents/subcomponents.dart';
import 'package:flutter/material.dart';
import 'package:autodo/items/repeateditor.dart';
import 'package:autodo/items/repeat.dart';

List<Repeat> defaults = [
  Repeat("oil", 3500),
  Repeat("tireRotation", 7500),
  Repeat("engineFilter", 45000),
  Repeat("wiperBlades", 30000),
  Repeat("alignmentCheck", 40000),
  Repeat("cabinFilter", 45000),
  Repeat("tires", 50000),
  Repeat("brakes", 60000),
  Repeat("sparkPlugs", 60000),
  Repeat("frontStruts", 75000),
  Repeat("rearStruts", 75000),
  Repeat("battery", 75000),
  Repeat("serpentineBelt", 150000),
  Repeat("transmissionFluid", 100000),
  Repeat("coolantChange", 100000)
];

class RepeatingBLoC extends BLoC {
  static final Firestore _db = Firestore.instance;
  Repeat _past;
  List<Repeat> repeats = defaults;
  /**
   * Maps containing the related tasks for each repeating task type.
   * Example Map:
   * 
   * "carName": {
   *   "repeatKey": {
   *     // MaintenanceTodoItem contents
   *     "name": "todoName",
   *     "dueMileage": xxx  
   *   }
   * }
   */
  Map<String, Map<String, Map<String, dynamic>>> upcomingRepeatTodos = Map();
  Map<String, Map<String, dynamic>> latestCompletedRepeatTodos = Map();

  final StreamController editStream = StreamController();

  @override
  Widget buildItem(dynamic snapshot, int index) => RepeatEditor(item: Repeat.fromJSON(snapshot.data, snapshot.documentID));

  StreamBuilder items() {
    return buildList('repeats');
  }

  List<Repeat> _convertDocuments(List<DocumentSnapshot> docs) {
    List<Repeat> out = [];
    docs.forEach((doc) {
      out.add(Repeat(
          doc.data['name'], 
          doc.data['interval'], 
          ref: doc.documentID,
        ),
      );
    });
    return out;
  }

  bool _keyInRepeats(String key) {
    var out = false;
    repeats.forEach((repeat) {
      if (repeat.name == key) {
        out = true;
        return;
      }
    });
    return out; 
  }

  Repeat repeatByName(String name) {
    List<Repeat> matches = List.from(repeats.where((repeat) => repeat.name == name));
    if (matches.length == 1) return matches[0];
    else if (matches.length == 0) {
      try {
        return List.from(defaults.where((repeat) => repeat.name == name))[0];
      } catch (e) {
        print(e);
        return Repeat.empty();
      }
    }
    else {
      print("multiple repeats with the same name");
      return matches[0];
    }
  }

  /// Checks to see if the user has repeat intervals in their db collection
  /// If not, push the defaults
  Future<void> _checkForRepeats() async {
    // Determine if the repeating intervals are saved in the user's data
    // Currently hard-coded to have one car named default
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    QuerySnapshot snap = await userDoc
        .collection('repeats')
        .getDocuments();
    List<DocumentSnapshot> docs = snap.documents;
    if (docs.isNotEmpty) {
      repeats = _convertDocuments(docs);
    } else {
      pushRepeats(repeats);
    }
  }

  /// Finds a Map of the last completed todo in the repeating
  /// task categories.
  Future<void> _findLatestCompletedTodos(String car) async {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    Query completes = userDoc
                        .collection('todos')
                        .where("complete", isEqualTo: true)
                        .where("tags", arrayContains: car)
                        .orderBy("completeDate");
    QuerySnapshot docs = await completes.getDocuments();
    List<DocumentSnapshot> snaps = docs.documents;

    snaps.forEach((snap) {
      String taskType = snap.data['repeatingType'];
      if (!_keyInRepeats(taskType))
        return;
      // Initialize the Map if it is a new car
      if (latestCompletedRepeatTodos[car] == null)
        latestCompletedRepeatTodos[car] = {};
      if (!latestCompletedRepeatTodos[car].containsKey(taskType))
        latestCompletedRepeatTodos[car][taskType] = snap.data;
    });
  }

  /// Finds a Map of upcoming todo items in the repeating
  /// task categories.
  Future<void> _findUpcomingRepeatTodos(String car) async {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    Query completes = userDoc
      .collection('todos')
      .where("complete", isEqualTo: false)
      .where("tags", arrayContains: car)
      .orderBy("completeDate");
    QuerySnapshot docs = await completes.getDocuments();
    List<DocumentSnapshot> snaps = docs.documents;

    snaps.forEach((snap) {
      String taskType = snap.data['repeatingType'];
      if (!_keyInRepeats(taskType))
        return;
      if (upcomingRepeatTodos[car] == null)
        upcomingRepeatTodos[car] = {};
      if (!upcomingRepeatTodos[car].containsKey(taskType))
        upcomingRepeatTodos[car][taskType] = snap.data;
    });
  }

  // Find latest completed todos with ties to a repeat
  // Determine if the completed todo has an upcoming todo already
  // if not, find the interval for the todo and add that to the mileage where the completed todo ocurred
  // create new todo with that information
  Future<void> updateUpcomingTodos() async {
    await _checkForRepeats();
    

    List<Car> cars = await CarsBLoC().getCars();
    cars.forEach((car) async {
      await _findLatestCompletedTodos(car.name);
      await _findUpcomingRepeatTodos(car.name);
      repeats.forEach((repeat) {
        if (repeat == null) return;
        // Check if the upcoming ToDo for this category already exists
        if (upcomingRepeatTodos[car.name] == null || 
            !upcomingRepeatTodos[car.name].containsKey(repeat.name)) {
          int newDueMileage = repeat.interval;
          if (latestCompletedRepeatTodos[car.name] != null &&
              latestCompletedRepeatTodos[car.name].keys.contains(repeat.name)) {
            // If a ToDo in this category has already been completed, use that as
            // the base for extrapolating the dueMileage for the new ToDo
            newDueMileage += latestCompletedRepeatTodos[car.name][repeat.name]['completedMileage'];
          } else if (newDueMileage < (car.mileage * 0.75)) {
            // Add the repeat interval to the car's current mileage if the small
            // interval and high mileage makes it seem unlikely that the car
            // has not had this operation done at some point
            newDueMileage += car.mileage;
          }
          pushNewTodo(car.name, repeat.name, newDueMileage, false);
        }
      });
    });
  }

  Future<void> pushRepeats(List<Repeat> repeats) async {
    // creates a new unique identifier for the item
    repeats.forEach( (repeat) async {
      await pushItem('repeats', repeat);
    });
  }

  Future<void> push(Repeat item) async {
    item.cars.forEach((carName) async {
      var car = await CarsBLoC().getCarByName(carName);
      var dueMileage = car.mileage + item.interval;
      pushNewTodo(carName, item.name, dueMileage, false);
    });

    await pushItem('repeats', item);
  }

  void edit(Repeat item) {
    var prevItem = repeatByName(item.name);
    TodoBLoC().repeatUpdated(item, prevItem);
    editItem('repeats', item);
  }

  void delete(Repeat item) {
    deleteItem('repeats', item);
  }

  void undo() {
    undoItem('repeats');
  }
  
  void updateTodos(Repeat item) async {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    Query completes = userDoc
                        .collection('todos').where("complete", isEqualTo: false).orderBy("completeDate");
    QuerySnapshot docs = await completes.getDocuments();
    List<DocumentSnapshot> snaps = docs.documents;
    WriteBatch _batch = _db.batch();

    for (var snap in snaps) {
      var todo = snap.data;
      String taskType = snap.data['repeatingType'];
      if (taskType == item.name) {
        // use the difference in the previous and new intervals to update the dueMileage
        int prevInterval = repeatByName(taskType).interval ?? 0; // prevent exception on null value
        int curInterval = item.interval ?? 0;
        if (!todo.containsKey('dueMileage') || todo['dueMileage'] == null || prevInterval == curInterval)
          return;
        int curMileage = todo['dueMileage'] as int;
        todo['dueMileage'] = curMileage + (curInterval - prevInterval); 
      } 
      var updatedItem = MaintenanceTodoItem.fromMap(
        todo, 
        reference: userDoc.collection('todos').document(snap.documentID));
      _batch = await TodoBLoC().addUpdate(_batch, updatedItem);
    }
    _batch.commit();
  }

  void editRunner(dynamic item) {
    if (item.ref == null) return;
    updateTodos(item);
    edit(item);
  }

  void queueEdit(Repeat item) {
    if (!editStream.hasListener) {
      editStream.stream.listen(editRunner);
    }
    editStream.add(item);
  }

  void pushNewTodo(String carName, String taskName, int dueMileage, bool complete) async {
    MaintenanceTodoItem newTodo = MaintenanceTodoItem(  
      name: taskName,
      dueMileage: dueMileage,
      repeatingType: taskName,
      tags: [carName],
      complete: complete,
    );
    // await Auth().fetchUser();
    TodoBLoC().push(newTodo);
  }

  Future<void> editByName(String name, int interval) async {
    DocumentReference userDoc = FirestoreBLoC().getUserDocument();
    if (!_keyInRepeats(name)) return;
    var item = repeatByName(name);
    item.interval = interval;
    DocumentReference ref = userDoc
          .collection('repeats')
          .document(item.ref);
    ref.updateData(item.toJSON());
  }

  Future<void> setLastCompleted(String repeat, int mileage) async {
    if (!_keyInRepeats(repeat)) return;
    // XXX: currently defaulting to using the first car for the new user,
    // not sure if that's ideal
    List<Car> cars = await CarsBLoC().getCars();
    var car = cars[0];
    pushNewTodo(car.name, repeat, mileage, true);
  }

  // Make the object a Singleton
  static final RepeatingBLoC _self = RepeatingBLoC._internal();
  factory RepeatingBLoC() {
    return _self;
  }
  RepeatingBLoC._internal();
}
