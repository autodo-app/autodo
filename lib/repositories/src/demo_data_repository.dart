import 'dart:async';
import 'dart:math';

import '../../models/models.dart';
import '../../units/units.dart';
import '../repositories.dart';
import 'data_repository.dart';
import 'write_batch_wrapper.dart';

class DemoDataRepository extends DataRepository {
  DemoDataRepository();

  static const carName = 'Christine';
  static const startMileage = 1000.0 * Distance.kilometer;
  static const averageLiterPer100Km =
      10.0 * Volume.liter / Distance.kilometer; // l/100 km
  static const averageLiterPerKm = averageLiterPer100Km / 100.0; // l/km
  static const averageEfficiency = 1.0 / averageLiterPerKm; // km/l
  static const literPrice = 1.0; // USD/l

  @override
  Future<List<Car>> getCurrentCars() async {
    var mileage = startMileage;

    final refs = await getCurrentRefuelings();
    final dr = <DistanceRatePoint>[];

    for (final ref in refs) {
      dr.add(DistanceRatePoint(
        ref.odomSnapshot.date,
        ref.odomSnapshot.mileage - mileage,
      ));
      mileage = ref.odomSnapshot.mileage;
    }

    return <Car>[
      Car(
          id: 'demo',
          name: carName,
          averageEfficiency: 2.0,
          distanceRate: 2.0,
          distanceRateHistory: dr,
          odomSnapshot: OdomSnapshot(car: 'demo', date: dr.last.date, mileage: mileage),
          numRefuelings: refs.length,
          make: 'Plymouth',
          model: 'Fury',
          year: 1958,
          plate: 'CBQ 241',
          imageName:
              'https://upload.wikimedia.org/wikipedia/commons/9/9c/Christine.jpg')
    ];
  }

  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    final startDate = DateTime(2018, 10, 1, 12).millisecondsSinceEpoch;
    final endDate = DateTime.now().millisecondsSinceEpoch;
    final rnd = Random(987234);

    final refuelings = <Refueling>[];
    var mileage = startMileage;
    var date = startDate;
    var lastDate = startDate;

    while (date < endDate) {
      date += Duration(days: 1 + rnd.nextInt(10)).inMilliseconds;
      final angle = (date - startDate) / 5000000000.0;
      final kmPerDay = (5.0 + cos(angle * 1.5)) * 5 * Distance.kilometer;
      final days = Duration(milliseconds: date - lastDate).inDays;
      final distance = kmPerDay * days; // km
      final efficiency =
          averageEfficiency + sin(angle) * averageEfficiency / 10; // km/l

      final amount = distance / efficiency; // l
      final cost = amount * literPrice; // USD

      if (amount > 50 * Volume.liter) continue;

      mileage += distance;
      lastDate = date;

      refuelings.add(Refueling(
        id: '${refuelings.length}',
        odomSnapshot: OdomSnapshot(car: 'demo', date: DateTime.fromMillisecondsSinceEpoch(date), mileage: mileage),
        amount: amount,
        cost: cost,
        efficiency: efficiency,
      ));
    }

    return refuelings;
  }

  @override
  Future<Car> addNewCar(Car car) {
    throw UnimplementedError();
  }

  @override
  Future<Refueling> addNewRefueling(Refueling refueling) {
    throw UnimplementedError();
  }

  @override
  Future<Todo> addNewTodo(Todo todo) {
    throw UnimplementedError();
  }

  @override
  Future<OdomSnapshot> addNewOdomSnapshot(OdomSnapshot snapshot) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCar(Car car) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRefueling(Refueling refueling) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodo(Todo todo) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteOdomSnapshot(OdomSnapshot snapshot) {
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>> getCurrentTodos() async {
    return <Todo>[
      Todo(
        name: 'Oil Change',
        carId: 'demo',
        completed: false,
        dueMileage: startMileage + 1000 * Distance.kilometer,
        mileageRepeatInterval: 2000 * Distance.kilometer,
      ),
      Todo(
        name: 'Tire Change',
        carId: 'demo',
        completed: false,
        dueMileage: startMileage + 1500 * Distance.kilometer,
        mileageRepeatInterval: 6000 * Distance.kilometer,
      ),
    ];
  }

  @override 
  Future<List<OdomSnapshot>> getCurrentOdomSnapshots() async {
    return <OdomSnapshot>[];
  }

  @override
  Future<bool> getPaidStatus() async {
    return true;
  }

  @override
  Stream<int> notificationID() async* {}

  @override
  FutureOr<WriteBatchWrapper<Car>> startCarWriteBatch() {
    return DemoWriteBatch<Car>();
  }

  @override
  FutureOr<WriteBatchWrapper<Refueling>> startRefuelingWriteBatch() {
    return DemoWriteBatch<Refueling>();
  }

  @override
  FutureOr<WriteBatchWrapper<Todo>> startTodoWriteBatch() {
    return DemoWriteBatch<Todo>();
  }

  @override
  FutureOr<WriteBatchWrapper<OdomSnapshot>> startOdomSnapshotWriteBatch() {
    return DemoWriteBatch<OdomSnapshot>();
  }


  @override
  Future<Car> updateCar(Car car) {
    throw UnimplementedError();
  }

  @override
  Future<Refueling> updateRefueling(Refueling refueling) {
    throw UnimplementedError();
  }

  @override
  Future<Todo> updateTodo(Todo todo) {
    throw UnimplementedError();
  }

  @override
  Future<OdomSnapshot> updateOdomSnapshot(OdomSnapshot snapshot) {
    throw UnimplementedError();
  }

  @override
  List<Object> get props => [];

  @override
  Future<List<Map<String, dynamic>>> getRepeats() {
    throw UnimplementedError();
  }
}

class DemoWriteBatch<T extends WriteBatchDocument>
    extends WriteBatchWrapper<T> {
  DemoWriteBatch();

  @override
  Future<Map<WRITE_OPERATION, dynamic>> commit() async => {};

  @override
  void setData(data) {}

  @override
  void updateData(String da, data) {}

  @override
  List<Object> get props => [];
}
