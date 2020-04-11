import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:semaphore/semaphore.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

import '../../generated/pubspec.dart';
import '../../models/models.dart';
import '../repositories.dart';
import 'data_repository.dart';
import 'sembast_write_batch.dart';
import 'write_batch_wrapper.dart';

class SembastDataRepository extends DataRepository {
  SembastDataRepository._(this.db);

  final Database db;

  static final Semaphore dbLock = LocalSemaphore(255);

  /// Main constructor for the object.
  ///
  /// Set up this way to allow for asynchronous behavior in the ctor. Will
  /// check the user's current database version against the expected
  /// version and migrate the data if needed.
  static Future<SembastDataRepository> open({
    @deprecated createDb,
    DatabaseFactory dbFactory,
    String dbPath,
    FutureOr<Directory> Function() pathProvider,
  }) async {
    final path = await getFullPath(dbPath: dbPath, pathProvider: pathProvider);

    dbFactory ??= databaseFactoryIo;
    await dbLock.acquire();

    final db = await dbFactory.openDatabase(
      path,
      mode: DatabaseMode.neverFails,
      version: Pubspec.db_version,
      onVersionChanged: _upgrade,
    );
    dbLock.release();

    return SembastDataRepository._(db);
  }

  static Future<String> getFullPath({
    String dbPath,
    FutureOr<Directory> Function() pathProvider,
  }) async {
    dbPath ??= 'sample.db';
    pathProvider ??= getApplicationDocumentsDirectory;

    final path = await pathProvider();
    return join('${path.path}', dbPath);
  }

  static Future<void> deleteDb(String path, [DatabaseFactory dbFactory]) async {
    dbFactory ??= databaseFactoryIo;
    await dbFactory.deleteDatabase(path);
  }

  static Future<void> _upgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion == 0) {
      // new database, no update needed
      return;
    }

    final dr = SembastDataRepository._(db);

    await dr.upgrade(oldVersion, newVersion);
  }

  StoreRef get _todos => StoreRef('todos');

  final StreamController<List<Todo>> _todosStream =
      StreamController<List<Todo>>.broadcast();

  StoreRef get _refuelings => StoreRef('refuelings');

  final StreamController<List<Refueling>> _refuelingsStream =
      StreamController<List<Refueling>>.broadcast();

  StoreRef get _cars => StoreRef('cars');

  final StreamController<List<Car>> _carsStream =
      StreamController<List<Car>>.broadcast();

  final StreamController<int> _notificationIdStream =
      StreamController<int>.broadcast();

  final Completer<Database> dbCompleter = Completer<Database>();

  @override
  Future<void> addNewTodo(Todo todo) async {
    await dbLock.acquire();
    try {
      await _todos.add(db, todo.toDocument());
      _todosStream.add(await getCurrentTodos());
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await dbLock.acquire();
    try {
      await _todos.record(todo.id).put(db, todo.toDocument());
      _todosStream.add(await getCurrentTodos());
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await dbLock.acquire();
    try {
      await _todos.record(todo.id).delete(db);
      _todosStream.add(await getCurrentTodos());
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
    try {
      final list = await _todos.find(db);
      final out = list.map((snap) => Todo.fromRecord(snap)).toList()
        ..sort((a, b) => int.parse(a.id) > int.parse(b.id) ? 1 : -1);
      return out;
    } finally {
      dbLock.release();
    }
  }

  @override
  FutureOr<WriteBatchWrapper> startTodoWriteBatch() async {
    return SembastWriteBatch(this, store: _todos);
  }

  // Refuelings
  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    await dbLock.acquire();
    try {
      final list = await _refuelings.find(db,
          finder: Finder(sortOrders: [SortOrder('mileage')]));
      final out = list.map((snap) => Refueling.fromRecord(snap)).toList();
      return out;
    } finally {
      dbLock.release();
    }
  }

  Future<void> refuelingStreamUpdate() async {
    _refuelingsStream.add(await getCurrentRefuelings());
  }

  @override
  Future<void> addNewRefueling(Refueling refueling) async {
    await dbLock.acquire();
    try {
      await _refuelings.add(db, refueling.toDocument());
      await refuelingStreamUpdate();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> updateRefueling(Refueling refueling) async {
    await dbLock.acquire();
    try {
      await _refuelings.record(refueling.id).put(db, refueling.toDocument());
      await refuelingStreamUpdate();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> deleteRefueling(Refueling refueling) async {
    await dbLock.acquire();
    try {
      await _refuelings.record(refueling.id).delete(db);
      await refuelingStreamUpdate();
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
      this,
      store: _refuelings,
      streamControllerUpdate: refuelingStreamUpdate,
    );
  }

  // Cars

  @override
  Future<List<Car>> getCurrentCars() async {
    await dbLock.acquire();
    try {
      final list = await _cars.find(db,
          finder: Finder(sortOrders: [SortOrder('mileage')]));
      final out = list.map((snap) => Car.fromRecord(snap)).toList();
      return out;
    } finally {
      dbLock.release();
    }
  }

  Future<void> carStreamUpdate() async {
    _carsStream.add(await getCurrentCars());
  }

  @override
  Future<void> addNewCar(Car car) async {
    await dbLock.acquire();
    try {
      await _cars.add(db, car.toDocument());
      await carStreamUpdate();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> updateCar(Car car) async {
    await dbLock.acquire();
    try {
      await _cars.record(car.id).put(db, car.toDocument());
      await carStreamUpdate();
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<void> deleteCar(Car car) async {
    await dbLock.acquire();
    try {
      await _cars.record(car.id).delete(db);
      await carStreamUpdate();
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
      this,
      store: _cars,
      streamControllerUpdate: carStreamUpdate,
    );
  }

  @override
  Stream<int> notificationID() {
    return _notificationIdStream.stream;
  }

  @override
  Future<bool> getPaidStatus() async {
    await dbLock.acquire();
    try {
      final out = await StoreRef.main()
          .findKey(db, finder: Finder(filter: Filter.byKey('paid')));
      return out;
    } finally {
      dbLock.release();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRepeats() async {
    await dbLock.acquire();
    try {
      final repeats = await StoreRef('repeats').find(db);
      return repeats.map<Map<String, dynamic>>((r) => r.value).toList();
    } finally {
      dbLock.release();
    }
  }

  Future<void> close() async {
    await dbLock.acquire();
    try {
      await db.close();
    } catch (e) {
      print(e);
    } finally {
      dbLock.release();
    }
  }

  @override
  List<Object> get props => [];
}
