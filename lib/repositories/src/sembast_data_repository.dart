import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/entities/entities.dart';
import 'data_repository.dart';
import 'write_batch_wrapper.dart';
import 'sembast_write_batch.dart';

class SembastDataRepository extends Equatable implements DataRepository {
  // File path to a file in the current directory
  final String dbPath;
  final DatabaseFactory dbFactory;
  StoreRef get _todos => StoreRef('todos');
  final StreamController<List<Todo>> _todosStream = 
    StreamController<List<Todo>>.broadcast();
  StoreRef get _refuelings => StoreRef('refuelings');
  final StreamController<List<Refueling>> _refuelingsStream = 
    StreamController<List<Refueling>>.broadcast();
  StoreRef get _cars => StoreRef('cars');
  final StreamController<List<Car>> _carsStream = 
    StreamController<List<Car>>.broadcast();
  StoreRef get _repeats => StoreRef('repeats');
  final StreamController<List<Repeat>> _repeatsStream = 
    StreamController<List<Repeat>>.broadcast();
  final StreamController<int> _notificationIdStream = 
    StreamController<int>.broadcast();
  final Completer<Database> dbCompleter = Completer<Database>();
  Future<Directory> Function() pathProvider;

  Future<String> _getFullFilePath() async {
    final path = await pathProvider();
    return path.path + '/' + dbPath;
  }
  Future<Database> openDb(createDb) async {
    final filePath = await _getFullFilePath();
    if (createDb) {
      await dbFactory.deleteDatabase(await _getFullFilePath());
      final db = await dbFactory.openDatabase(filePath, mode: DatabaseMode.create);
      return db;
    } else {
      try {
        final db = await dbFactory.openDatabase(filePath, mode: DatabaseMode.existing);
        return db;
      } on DatabaseException catch (e) {
        print(e);
        // Just create the db when we can't find an existing one? 
        // not sure how to best handle this scenario...
        return dbFactory.openDatabase(filePath, mode: DatabaseMode.create);
      }
      
    }
  }

  SembastDataRepository({
    @required createDb,
    dbFactory,
    this.dbPath = 'sample.db',
    pathProvider
  }) : this.dbFactory = dbFactory ?? databaseFactoryIo, 
      this.pathProvider = pathProvider ?? getApplicationDocumentsDirectory {
    dbCompleter.complete(openDb(createDb));
  }

  Future<Database> get db => dbCompleter.future;

  Future<void> load() async {
    await refuelingStreamUpdate();
  }

  @override 
  Future<void> addNewTodo(Todo todo) async {
    await _todos.add(await db, todo.toEntity().toDocument());
    _todosStream.add(await getCurrentTodos());
  }

  @override 
  Future<void> updateTodo(Todo todo) async {
    await _todos.update(
      await db, 
      todo.toEntity().toDocument(), 
      finder: Finder(filter: Filter.byKey(todo.id)));
    _todosStream.add(await getCurrentTodos());
  }

  @override 
  Future<void> deleteTodo(Todo todo) async {
    await _todos.delete(await db, finder: Finder(filter: Filter.byKey(todo.id)));
    _todosStream.add(await getCurrentTodos());
  }

  @override 
  Stream<List<Todo>> todos() {
    return _todosStream.stream;
  }

  Future<List<Todo>> getCurrentTodos() async {
    var list = await _todos.find(await db);
    return list.map((snap) => Todo.fromEntity(TodoEntity.fromRecord(snap))).toList();
  }

  @override
  FutureOr<WriteBatchWrapper> startTodoWriteBatch() async {
    return SembastWriteBatch(database: await db, store: _todos);
  }

  // Refuelings
  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    var list = await _refuelings.find(await db, finder: Finder(sortOrders: [SortOrder('mileage')]));
    return list.map((snap) => Refueling.fromEntity(RefuelingEntity.fromRecord(snap))).toList();
  }

  Future<void> refuelingStreamUpdate() async {
    _refuelingsStream.add(await getCurrentRefuelings());
  } 

  @override 
  Future<void> addNewRefueling(Refueling refueling) async {
    await _refuelings.add(await db, refueling.toEntity().toDocument());
    refuelingStreamUpdate();
  }

  @override 
  Future<void> updateRefueling(Refueling refueling) async {
    await _refuelings.update(
      await db, 
      refueling.toEntity().toDocument(), 
      finder: Finder(filter: Filter.byKey(refueling.id)));
    refuelingStreamUpdate();
  }

  @override 
  Future<void> deleteRefueling(Refueling refueling) async {
    await _refuelings.delete(await db, finder: Finder(filter: Filter.byKey(refueling.id)));
    refuelingStreamUpdate();
  }

  @override 
  Stream<List<Refueling>> refuelings([bool forceRefresh]) async* {
    await refuelingStreamUpdate(); 
    yield* _refuelingsStream.stream;
  }

  @override
  FutureOr<WriteBatchWrapper> startRefuelingWriteBatch() async {
    return SembastWriteBatch(
      store: _refuelings,
      database: await db,
      streamControllerUpdate: refuelingStreamUpdate
    );
  }

  // Cars

  Future<List<Car>> getCurrentCars() async {
    var list = await _cars.find(await db, finder: Finder(sortOrders: [SortOrder('mileage')]));
    return list.map((snap) => Car.fromEntity(CarEntity.fromRecord(snap))).toList();
  } 

  Future<void> carStreamUpdate() async {
    _carsStream.add(await getCurrentCars());
  }

  @override 
  Future<void> addNewCar(Car car) async {
    await _cars.add(await db, car.toEntity().toDocument());
    carStreamUpdate();
  }

  @override 
  Future<void> updateCar(Car car) async {
    await _cars.update(
      await db, 
      car.toEntity().toDocument(), 
      finder: Finder(filter: Filter.byKey(car.id)));
    carStreamUpdate();
  }

  @override 
  Future<void> deleteCar(Car car) async {
    await _cars.delete(await db, finder: Finder(filter: Filter.byKey(car.id)));
    carStreamUpdate();
  }

  @override 
  Stream<List<Car>> cars() {
    return _carsStream.stream;
  }

  @override
  FutureOr<WriteBatchWrapper> startCarWriteBatch() async {
    return SembastWriteBatch(database: await db, store: _cars, streamControllerUpdate: carStreamUpdate);
  }

  // Repeats

  Future<List<Repeat>> getCurrentRepeats() async {
    var list = await _repeats.find(await db);
    return list.map((snap) => Repeat.fromEntity(RepeatEntity.fromRecord(snap))).toList();
  } 

  Future<void> _repeatsUpdateStream() async {
    _repeatsStream.add(await getCurrentRepeats());
  }

  @override 
  Future<List<Repeat>> addNewRepeat(Repeat repeat) async {
    await _repeats.add(await db, repeat.toEntity().toDocument());
    _repeatsUpdateStream();
    var list = await _repeats.find(await db);
    return list.map((snap) => Repeat.fromEntity(RepeatEntity.fromRecord(snap))).toList();
  }

  @override 
  Future<void> updateRepeat(Repeat repeat) async {
    await _repeats.update(
      await db, 
      repeat.toEntity().toDocument(), 
      finder: Finder(filter: Filter.byKey(repeat.id)));
    _repeatsUpdateStream();
  }

  @override 
  Future<void> deleteRepeat(Repeat repeat) async {
    await _repeats.delete(await db, finder: Finder(filter: Filter.byKey(repeat.id)));
    _repeatsUpdateStream();
  }

  @override 
  Stream<List<Repeat>> repeats() {
    return _repeatsStream.stream;
  }

  @override
  FutureOr<WriteBatchWrapper> startRepeatWriteBatch() async {
    return SembastWriteBatch(database: await db, store: _repeats, streamControllerUpdate: _repeatsUpdateStream);
  }

  @override 
  Stream<int> notificationID() {
    return _notificationIdStream.stream;
  }

  Future<void> deleteDb() async {
    await dbFactory.deleteDatabase(await _getFullFilePath());
  }

  @override 
  List<Object> get props => [];
}