import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import '../../../models/models.dart';
import '../cars/barrel.dart';
import '../todos/barrel.dart';
import 'event.dart';
import 'state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  FilteredTodosBloc({@required this.todosBloc, @required this.carsBloc}) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoaded) {
        add(UpdateTodos(state.todos));
      }
    });
    carsSubscription = carsBloc.listen((state) {
      if (state is CarsLoaded) {
        add(UpdateCars(state.cars));
      }
    });
  }

  final TodosBloc todosBloc;
  final CarsBloc carsBloc;

  StreamSubscription todosSubscription, carsSubscription;

  @override
  FilteredTodosState get initialState {
    return todosBloc.state is TodosLoaded && carsBloc.state is CarsLoaded
        ? FilteredTodosLoaded(
            sortItems(_setDueState((todosBloc.state as TodosLoaded).todos,
                (carsBloc.state as CarsLoaded).cars)),
            VisibilityFilter.all,
          )
        : FilteredTodosLoading();
  }

  @override
  Stream<FilteredTodosState> mapEventToState(FilteredTodosEvent event) async* {
    if (event is UpdateTodosFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateTodos) {
      yield* _mapTodosUpdatedToState(event);
    } else if (event is UpdateCars) {
      yield* _mapCarsUpdatedToState(event);
    }
  }

  static Map<TodoDueState, List<Todo>> sortItems(List<Todo> items) {
    items.sort((a, b) {
      if ((a.completed ?? false) && (!b.completed ?? false)) {
        return -1;
      } else if ((b.completed ?? false) && (!a.completed ?? false)) {
        return 1;
      }

      final aDate = a?.dueDate;
      final bDate = b?.dueDate;
      final aMileage = a?.dueMileage ?? 0;
      final bMileage = b?.dueMileage ?? 0;

      if (aDate == null || bDate == null) {
        // both don't have a date, so only consider the mileages
        if (aMileage > bMileage) {
          return 1;
        } else if (aMileage < bMileage) {
          return -1;
        } else {
          return 0;
        }
      } else {
        // consider the dates since all todo items should have dates as a result
        // of the distance rate translation function
        return aDate.compareTo(bDate);
      }
    });
    return groupBy<Todo, TodoDueState>(items, (t) => t.dueState);
  }

  Stream<FilteredTodosState> _mapUpdateFilterToState(
    UpdateTodosFilter event,
  ) async* {
    if (todosBloc.state is TodosLoaded) {
      yield FilteredTodosLoaded(
        _filterTodos(
          (todosBloc.state as TodosLoaded).todos,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredTodosState> _mapTodosUpdatedToState(
    UpdateTodos event,
  ) async* {
    var updatedTodos = event.todos;
    if (carsBloc.state is CarsLoaded) {
      updatedTodos =
          _setDueState(event.todos, (carsBloc.state as CarsLoaded).cars);
    }
    final visibilityFilter = state is FilteredTodosLoaded
        ? (state as FilteredTodosLoaded).activeFilter
        : VisibilityFilter.all;
    yield FilteredTodosLoaded(
      _filterTodos(
        updatedTodos,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  Stream<FilteredTodosState> _mapCarsUpdatedToState(UpdateCars event) async* {
    if (!(state is FilteredTodosLoaded)) {
      // can't update the dueState for ToDos if we don't have any yet
      return;
    }
    final updatedTodos =
        _setDueState((todosBloc.state as TodosLoaded).todos, event.cars);
    final visibilityFilter = state is FilteredTodosLoaded
        ? (state as FilteredTodosLoaded).activeFilter
        : VisibilityFilter.all;
    yield FilteredTodosLoaded(
      _filterTodos(
        updatedTodos,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  List<Todo> _setDueState(List<Todo> todos, List<Car> cars) {
    return todos.map((t) {
      final curCar = cars.firstWhere((c) => c.name == t.carName);
      return t.copyWith(dueState: TodosBloc.calcDueState(curCar, t));
    }).toList();
  }

  Map<TodoDueState, List<Todo>> _filterTodos(
      List<Todo> todos, VisibilityFilter filter) {
    final filtered = todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.completed;
      } else {
        return todo.completed;
      }
    }).toList();
    return sortItems(filtered);
  }

  @override
  Future<void> close() {
    todosSubscription?.cancel();
    carsSubscription?.cancel();
    return super.close();
  }
}
