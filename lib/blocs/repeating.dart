import 'package:autodo/blocs/todo.dart';
import 'package:autodo/blocs/carstats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autodo/refueling/refuelingcard.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/userauth.dart';
import 'dart:collection';

const Map<String, dynamic> defaults = {
  "oil": 3500,
  "tireRotation": 7500,
  "engineFilter": 45000,
  "wiperBlades": 30000,
  "alignmentCheck": 40000,
  "cabinFilter": 45000,
  "tires": 50000,
  "brakes": 60000,
  "sparkPlugs": 60000,
  "frontStruts": 75000,
  "rearStruts": 75000,
  "battery": 75000,
  "serpentineBelt": 150000,
  "transmissionFluid": 100000,
  "coolantChange": 100000
};

class RepeatingBLoC {
  static final Firestore _db = Firestore.instance;
  static final CollectionReference todosCollection = _db
      .collection('users')
      .document(Auth().getCurrentUser())
      .collection('todos');

  Map<String, dynamic> repeats = defaults;
  /// Maps containing the related tasks for each repeating task type.
  /// Example Map:
  /// "repeatKey": {
  ///   {
  ///     // MaintenanceTodoItem contents
  ///     "name": "todoName",
  ///     "dueMileage": xxx  
  ///   }
  /// }
  Map<String, Map<String, dynamic>> upcomingRepeatTodos = Map();
  Map<String, Map<String, dynamic>> latestCompletedRepeatTodos = Map();

  /// Kudos to the SO post here:
  /// https://stackoverflow.com/questions/50875873/sort-maps-in-dart-by-key-or-by-value
  Map<String, dynamic> orderedRepeats() {
    return SplayTreeMap.from(repeats, (a, b) => repeats[a].compareTo(repeats[b]));
  }

  /// Checks to see if the user has repeat intervals in their db collection
  /// If not, push the defaults
  Future<void> checkRepeats() async {
    // Determine if the repeating intervals are saved in the user's data
    // Currently hard-coded to have one car named default
    DocumentSnapshot snap = await _db
        .collection('users')
        .document(Auth().getCurrentUser())
        .collection('repeats')
        .document('default')
        .get();
    if (snap.data != null) {
      repeats = snap.data;
    } else {
      pushRepeats('default', repeats);
    }
  }

  /// Finds a Map of the last completed todo in the repeating
  /// task categories.
  Future<void> findLatestCompletedTodos() async {
    Query completes = todosCollection
                        .where("complete", isEqualTo: true)
                        .orderBy("completeDate");
    QuerySnapshot docs = await completes.getDocuments();
    List<DocumentSnapshot> snaps = docs.documents;

    snaps.forEach((snap) {
      String taskType = snap.data['repeatingType'];
      if (!repeats.containsKey(taskType))
        return;
      if (!latestCompletedRepeatTodos.containsKey(taskType))
        latestCompletedRepeatTodos[taskType] = snap.data;
    });
  }

  /// Finds a Map of upcoming todo items in the repeating
  /// task categories.
  Future<void> findUpcomingRepeatTodos() async {
    Query completes = todosCollection.where("complete", isEqualTo: false).orderBy("completeDate");
    QuerySnapshot docs = await completes.getDocuments();
    List<DocumentSnapshot> snaps = docs.documents;

    snaps.forEach((snap) {
      String taskType = snap.data['repeatingType'];
      if (!repeats.containsKey(taskType))
        return;
      if (!upcomingRepeatTodos.containsKey(taskType))
        upcomingRepeatTodos[taskType] = snap.data;
    });
  }

  // Find latest completed todos with ties to a repeat
  // Determine if the completed todo has an upcoming todo already
  // if not, find the interval for the todo and add that to the mileage where the completed todo ocurred
  // create new todo with that information
  Future<void> updateUpcomingTodos() async {
    await findLatestCompletedTodos();
    await findUpcomingRepeatTodos();

    repeats.forEach((name, interval) {
      // Check if the upcoming ToDo for this category already exists
      if (!upcomingRepeatTodos.containsKey(name)) {
        int newDueMileage = interval;
        if (latestCompletedRepeatTodos.keys.contains(name)) {
          // If a ToDo in this category has already been completed, use that as
          // the base for extrapolating the dueMileage for the new ToDo
          newDueMileage += latestCompletedRepeatTodos[name]['completedMileage'];
        } else if (newDueMileage > CarStatsBLoC().getCurrentMileage()) {
          // Add the repeat interval to the car's current mileage if the small
          // interval and high mileage makes it seem unlikely that the car
          // has not had this operation done at some point
          // TODO: referenced in #36
          newDueMileage += CarStatsBLoC().getCurrentMileage();
        }
        pushNewTodo('default', name, newDueMileage);
      }
    });
  }

  // TODO: this should probably get covered by something else
  addExtraneousTodos() {
    // add in any maintenance todo items that aren't included in the repeating set here
  }

  void pushRepeats(String carName, Map<String, dynamic> repeat) {
    _db.runTransaction((transaction) async {
      // creates a new unique identifier for the item
      DocumentReference ref = _db
          .collection('users')
          .document(Auth().getCurrentUser())
          .collection('repeats')
          .document(carName);
      await transaction.set(ref, repeats);
    });
  }

  void pushNewTodo(String carName, String taskName, int dueMileage) {
    MaintenanceTodoItem newTodo = MaintenanceTodoItem.empty();
    newTodo.name = taskName;
    newTodo.dueMileage = dueMileage;
    FirebaseTodoBLoC().push(newTodo);
  }

  // Make the object a Singleton
  static final RepeatingBLoC _self = RepeatingBLoC._internal();
  factory RepeatingBLoC() {
    return _self;
  }
  RepeatingBLoC._internal();
}
