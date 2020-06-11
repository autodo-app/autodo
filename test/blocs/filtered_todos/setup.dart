import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import '../mocks.dart';

final completedSnap = OdomSnapshot(  
  date: DateTime.now(),
  mileage: 1000,
  car: 'test'
);
final todo = Todo(
    name: 'Oil',
    id: '0',
    carId: 'test',
    dueState: TodoDueState.DUE_SOON,
    dueMileage: 1000,
    notificationID: 0,
    completed: false,
    estimatedDueDate: false,
    completedOdomSnapshot: completedSnap,
    dueDate: DateTime.now());

FilteredTodosBloc buildFunc() {
  final dataBloc = MockDataBloc();
  when(dataBloc.state).thenReturn(DataLoaded(todos: [todo]));
  whenListen(
    dataBloc,
    Stream<DataState>.fromIterable([
      DataLoaded(todos: [todo])
    ]),
  );
  return FilteredTodosBloc(dataBloc: dataBloc);
}