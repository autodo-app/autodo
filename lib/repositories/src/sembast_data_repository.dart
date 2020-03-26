import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:semaphore/semaphore.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../../generated/pubspec.dart';
import '../../models/models.dart';
import '../repositories.dart';
import 'data_repository.dart';
import 'sembast_write_batch.dart';
import 'write_batch_wrapper.dart';

class SembastDataRepository extends DataRepository {
  SembastDataRepository._(
      {@required createDb, dbFactory, this.dbPath, pathProvider})
      : dbFactory = dbFactory ?? databaseFactoryIo,
        pathProvider = pathProvider ?? getApplicationDocumentsDirectory;

  Future<void> _setDatabaseVersion(int version) async {
    await dbLock.acquire();
    final _db = await _openDb();
    await StoreRef.main().record('version').put(_db, version);
    await _db.close();
    dbLock.release();
  }

  Future<void> _upgrade(bool createDb) async {
    final dbVersion = Pubspec.db_version;
    await dbLock.acquire();
    final _db = await _openDb();
    final curVersion = _db.version;
    await _db.close();
    dbLock.release();

    if (createDb) {
      await _setDatabaseVersion(dbVersion);
    } else if (curVersion != dbVersion) {
      final newVersion = await upgrade(curVersion, dbVersion);
      if (newVersion == dbVersion) {
        // upgrade went successfully
        await _setDatabaseVersion(newVersion);
      }
    }
  }

  /// Main constructor for the object.
  ///
  /// Set up this way to allow for asynchronous behavior in the ctor. Will
  /// check the user's current database version against the expected
  /// version and migrate the data if needed.
  static Future<SembastDataRepository> open(
      {@required createDb,
      dbFactory,
      dbPath = 'sample.db',
      pathProvider}) async {
    final out = SembastDataRepository._(
        createDb: createDb,
        dbFactory: dbFactory,
        dbPath: dbPath,
        pathProvider: pathProvider);
    await out._upgrade(createDb);
    return out;
  }

  static final Semaphore dbLock = LocalSemaphore(255);

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

  final Future<Directory> Function() pathProvider;

  Future<String> _getFullFilePath() async {
    final path = await pathProvider();
    return '${path.path}/$dbPath';
  }

  Future<Database> _openDb() async {
    final path = await _getFullFilePath();
    return await dbFactory.openDatabase(path, mode: DatabaseMode.neverFails);
  }

  @override
  Future<void> addNewTodo(Todo todo) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _todos.add(db, todo.toDocument());
      _todosStream.add(await getCurrentTodos());
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _todos.record(todo.id).put(db, todo.toDocument());
      _todosStream.add(await getCurrentTodos());
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _todos.record(todo.id).delete(db);
      _todosStream.add(await getCurrentTodos());
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Stream<List<Todo>> todos() {
    return _todosStream.stream;
  }

  @override
  Future<List<Todo>> getCurrentTodos() async {
    await dbLock.acquire();
    final db = await _openDb();
    final list = await _todos.find(db);
    final out = list.map((snap) => Todo.fromRecord(snap)).toList()
      ..sort((a, b) => int.parse(a.id) > int.parse(b.id) ? 1 : -1);
    await db.close();
    dbLock.release();
    return out;
  }

  @override
  FutureOr<WriteBatchWrapper> startTodoWriteBatch() async {
    return SembastWriteBatch(
        dbFactory: dbFactory,
        dbPath: await _getFullFilePath(),
        store: _todos,
        semaphore: dbLock);
  }

  // Refuelings
  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    await dbLock.acquire();
    final db = await _openDb();
    final list = await _refuelings.find(db,
        finder: Finder(sortOrders: [SortOrder('mileage')]));
    final out = list.map((snap) => Refueling.fromRecord(snap)).toList();
    await db.close();
    dbLock.release();
    return out;
  }

  Future<void> refuelingStreamUpdate() async {
    _refuelingsStream.add(await getCurrentRefuelings());
  }

  @override
  Future<void> addNewRefueling(Refueling refueling) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _refuelings.add(db, refueling.toDocument());
      await refuelingStreamUpdate();
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> updateRefueling(Refueling refueling) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _refuelings.record(refueling.id).put(db, refueling.toDocument());
      await refuelingStreamUpdate();
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> deleteRefueling(Refueling refueling) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _refuelings.record(refueling.id).delete(db);
      await refuelingStreamUpdate();
      await db.close();
    } finally {
      dbLock.release();
    }
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
        dbFactory: dbFactory,
        dbPath: await _getFullFilePath(),
        streamControllerUpdate: refuelingStreamUpdate,
        semaphore: dbLock);
  }

  // Cars

  @override
  Future<List<Car>> getCurrentCars() async {
    await dbLock.acquire();
    final db = await _openDb();
    final list = await _cars.find(db,
        finder: Finder(sortOrders: [SortOrder('mileage')]));
    final out = list.map((snap) => Car.fromRecord(snap)).toList();
    await db.close();
    dbLock.release();
    return out;
  }

  Future<void> carStreamUpdate() async {
    _carsStream.add(await getCurrentCars());
  }

  @override
  Future<void> addNewCar(Car car) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _cars.add(db, car.toDocument());
      await carStreamUpdate();
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> updateCar(Car car) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _cars.record(car.id).put(db, car.toDocument());
      await carStreamUpdate();
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> deleteCar(Car car) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _cars.record(car.id).delete(db);
      await carStreamUpdate();
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Stream<List<Car>> cars() {
    return _carsStream.stream;
  }

  @override
  FutureOr<WriteBatchWrapper> startCarWriteBatch() async {
    return SembastWriteBatch(
        dbFactory: dbFactory,
        dbPath: await _getFullFilePath(),
        store: _cars,
        streamControllerUpdate: carStreamUpdate,
        semaphore: dbLock);
  }

  // Repeats

  @override
  Future<List<Repeat>> getCurrentRepeats() async {
    await dbLock.acquire();
    final db = await _openDb();
    final list = await _repeats.find(db);
    final out =
        list.map((snap) => Repeat.fromEntity(Repeat.fromRecord(snap))).toList();
    await db.close();
    dbLock.release();
    return out;
  }

  Future<void> _repeatsUpdateStream() async {
    _repeatsStream.add(await getCurrentRepeats());
  }

  @override
  Future<void> addNewRepeat(Repeat repeat) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _repeats.add(db, repeat.toEntity().toDocument());
      await _repeatsUpdateStream();
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> updateRepeat(Repeat repeat) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _repeats.record(repeat.id).put(db, repeat.toEntity().toDocument());
      await _repeatsUpdateStream();
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> deleteRepeat(Repeat repeat) async {
    await dbLock.acquire();
    try {
      final db = await _openDb();
      await _repeats.record(repeat.id).delete(db);
      await _repeatsUpdateStream();
      await db.close();
    } finally {
      dbLock.release();
    }
  }

  @override
  Stream<List<Repeat>> repeats() {
    return _repeatsStream.stream;
  }

  @override
  FutureOr<WriteBatchWrapper> startRepeatWriteBatch() async {
    return SembastWriteBatch(
        dbFactory: dbFactory,
        dbPath: await _getFullFilePath(),
        store: _repeats,
        streamControllerUpdate: _repeatsUpdateStream,
        semaphore: dbLock);
  }

  @override
  Stream<int> notificationID() {
    return _notificationIdStream.stream;
  }

  @override
  Future<bool> getPaidStatus() async {
    await dbLock.acquire();
    final db = await _openDb();
    final out = await StoreRef.main()
        .findKey(db, finder: Finder(filter: Filter.byKey('paid')));
    await db.close();
    dbLock.release();
    return out;
  }

  Future<void> deleteDb() async {
    await dbFactory.deleteDatabase(await _getFullFilePath());
  }

  @override
  List<Object> get props => [];
}
