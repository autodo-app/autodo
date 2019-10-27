import 'dart:async';

import 'package:autodo/blocs/todo.dart';
import 'package:autodo/blocs/carstats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autodo/items/items.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:autodo/blocs/firestore.dart';
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

class RepeatingBLoC {
  static final Firestore _db = Firestore.instance;
  Repeat _past;
  List<Repeat> repeats = defaults;
  /**
   * Maps containing the related tasks for each repeating task type.
   * Example Map:
   * "repeatKey": {
   *   {
   *     // MaintenanceTodoItem contents
   *    "name": "todoName",
   *    "dueMileage": xxx  
   *  }
   * }
   */
  Map<String, Map<String, dynamic>> upcomingRepeatTodos = Map();
  Map<String, Map<String, dynamic>> latestCompletedRepeatTodos = Map();

  final StreamController editStream = StreamController();

  Widget _buildItem(BuildContext context, DocumentSnapshot snapshot) => RepeatEditor(item: Repeat.fromJSON(snapshot.data, snapshot.documentID));


  StreamBuilder buildList(BuildContext context) {
    if (FirestoreBLoC.isLoading()) return StreamBuilder();
    return StreamBuilder(
      stream: FirestoreBLoC.getUserDocument()
          .collection('repeats')
          .document('default')
          .collection('repeats')
          // .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        // sort data alphabetically by name
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _buildItem(context, snapshot.data.documents[index]),
        );
      },
    );
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
  Future<void> checkRepeats() async {
    // Determine if the repeating intervals are saved in the user's data
    // Currently hard-coded to have one car named default
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    QuerySnapshot snap = await userDoc
        .collection('repeats')
        .document('default')
        .collection('repeats')
        .getDocuments();
    List<DocumentSnapshot> docs = snap.documents;
    if (docs.isNotEmpty) {
      repeats = _convertDocuments(docs);
    } else {
      pushRepeats('default', repeats);
    }
  }

  /// Finds a Map of the last completed todo in the repeating
  /// task categories.
  Future<void> findLatestCompletedTodos() async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    Query completes = userDoc
                        .collection('todos')
                        .where("complete", isEqualTo: true)
                        .orderBy("completeDate");
    QuerySnapshot docs = await completes.getDocuments();
    List<DocumentSnapshot> snaps = docs.documents;

    snaps.forEach((snap) {
      String taskType = snap.data['repeatingType'];
      if (!_keyInRepeats(taskType))
        return;
      if (!latestCompletedRepeatTodos.containsKey(taskType))
        latestCompletedRepeatTodos[taskType] = snap.data;
    });
  }

  /// Finds a Map of upcoming todo items in the repeating
  /// task categories.
  Future<void> findUpcomingRepeatTodos() async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    Query completes = userDoc
                        .collection('todos').where("complete", isEqualTo: false).orderBy("completeDate");
    QuerySnapshot docs = await completes.getDocuments();
    List<DocumentSnapshot> snaps = docs.documents;

    snaps.forEach((snap) {
      String taskType = snap.data['repeatingType'];
      if (!_keyInRepeats(taskType))
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
    await checkRepeats();
    await findLatestCompletedTodos();
    await findUpcomingRepeatTodos();


    repeats.forEach((repeat) {
      // Check if the upcoming ToDo for this category already exists
      if (!upcomingRepeatTodos.containsKey(repeat.name)) {
        int newDueMileage = repeat.interval;
        if (latestCompletedRepeatTodos.keys.contains(repeat.name)) {
          // If a ToDo in this category has already been completed, use that as
          // the base for extrapolating the dueMileage for the new ToDo
          newDueMileage += latestCompletedRepeatTodos[repeat.name]['completedMileage'];
        } else if (newDueMileage > CarStatsBLoC().getCurrentMileage()) {
          // Add the repeat interval to the car's current mileage if the small
          // interval and high mileage makes it seem unlikely that the car
          // has not had this operation done at some point
          newDueMileage += CarStatsBLoC().getCurrentMileage();
        }
        pushNewTodo('default', repeat.name, newDueMileage);
      }
    });
  }

  // TODO: this should probably get covered by something else
  addExtraneousTodos() {
    // add in any maintenance todo items that aren't included in the repeating set here
  }

  Future<void> pushRepeats(String carName, List<Repeat> repeats) async {
    // creates a new unique identifier for the item
    DocumentReference doc = await FirestoreBLoC.fetchUserDocument();
    repeats.forEach( (repeat) async {
      DocumentReference ref = await doc
          .collection('repeats')
          .document(carName)
          .collection('repeats')
          .add(repeat.toJSON());
      ref.setData(repeat.toJSON());
    });
  }

  Future<void> push(String carName, Repeat repeat) async {
      // creates a new unique identifier for the item
      DocumentReference doc = await FirestoreBLoC.fetchUserDocument();
      DocumentReference ref = await doc
          .collection('repeats')
          .document(carName)
          .collection('repeats')
          .add(repeat.toJSON());
      ref.setData(repeat.toJSON());
  }

  Future<void> edit(Repeat item) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    if (item.ref == null) return;
    DocumentReference ref = userDoc
        .collection('repeats')
        .document('default')
        .collection('repeats')
        .document(item.ref);
    if (ref == null) return;
    ref.updateData(item.toJSON());
  }
  
  void updateTodos(Repeat item) async {
    // DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    // Query completes = userDoc
    //                     .collection('todos').where("complete", isEqualTo: false).orderBy("completeDate");
    // QuerySnapshot docs = await completes.getDocuments();
    // List<DocumentSnapshot> snaps = docs.documents;
    // WriteBatch _batch = _db.batch();

    // for (var snap in snaps) {
    //   var todo = snap.data;
    //   String taskType = snap.data['repeatingType'];
    //   if (taskType == item.name) {
    //     // use the difference in the previous and new intervals to update the dueMileage
    //     int prevInterval = repeatByName(taskType).interval ?? 0; // prevent exception on null value
    //     int curInterval = item.interval ?? 0;
    //     if (!todo.containsKey('dueMileage') || todo['dueMileage'] == null || prevInterval == curInterval)
    //       return;
    //     int curMileage = todo['dueMileage'] as int;
    //     todo['dueMileage'] = curMileage + (curInterval - prevInterval); 
    //   } 
    //   var updatedItem = MaintenanceTodoItem.fromMap(
    //     todo, 
    //     reference: userDoc.collection('todos').document(snap.documentID));
    //   _batch = await FirebaseTodoBLoC().addUpdate(_batch, updatedItem);
    // }
    // _batch.commit();
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

  void pushNewTodo(String carName, String taskName, int dueMileage) async {
    MaintenanceTodoItem newTodo = MaintenanceTodoItem(  
      name: taskName,
      dueMileage: dueMileage,
      repeatingType: taskName,
    );
    await Auth().fetchUser();
    FirebaseTodoBLoC().push(newTodo);
  }

  Future<void> delete(Repeat repeat) async {
    _past = repeat;
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    DocumentReference ref = userDoc
        .collection('repeats')
        .document('default')
        .collection('repeats')
        .document(repeat.ref);
    ref.delete();
  }

  void undo() {
    if (_past != null) pushRepeats('default', [_past]);
    _past = null;
  }

  List<Repeat> getSuggestions(String pattern) {
    RegExp regex = RegExp('*$pattern*'); // match anything with the pattern in it
    List<Repeat> out = [];
    for (var r in repeats) {
      if (regex.hasMatch(r.name)) out.add(r);
    }
    return repeats; 
  }

  Future<void> editByName(String name, int interval) async {
    DocumentReference userDoc = await FirestoreBLoC.fetchUserDocument();
    if (!_keyInRepeats(name)) return;
    var item = repeatByName(name);
    item.interval = interval;
    DocumentReference ref = userDoc
          .collection('repeats')
          .document('default')
          .collection('repeats')
          .document(item.ref);
    ref.updateData(item.toJSON());
  }

  // Make the object a Singleton
  static final RepeatingBLoC _self = RepeatingBLoC._internal();
  factory RepeatingBLoC() {
    return _self;
  }
  RepeatingBLoC._internal();
}
