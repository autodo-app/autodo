import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import '../../../models/models.dart';
import '../data/barrel.dart';
import 'event.dart';
import 'state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  FilteredTodosBloc({@required this.dataBloc}) {
    dataBlocSubscription = dataBloc.listen((state) {
      if (state is DataLoaded) {
        add(FilteredTodoDataUpdated(todos: state.todos, cars: state.cars));
      }
    });
  }

  final DataBloc dataBloc;

  StreamSubscription dataBlocSubscription;

  @override
  FilteredTodosState get initialState {
    return dataBloc.state is DataLoaded
        ? FilteredTodosLoaded(
            sortItems((dataBloc.state as DataLoaded).todos),
            VisibilityFilter.all,
          )
        : FilteredTodosLoading();
  }

  @override
  Stream<FilteredTodosState> mapEventToState(FilteredTodosEvent event) async* {
    if (event is UpdateTodosFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is FilteredTodoDataUpdated) {
      yield* _mapDataUpdatedToState(event);
    }
  }

  /// Sorts the ToDos based on their due mileage/date.
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

  /// Returns a filtered, organized Map of the ToDos according to their DueState.
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

  Stream<FilteredTodosState> _mapUpdateFilterToState(
    UpdateTodosFilter event,
  ) async* {
    if (state is FilteredTodosLoaded) {
      yield FilteredTodosLoaded(
        _filterTodos(
          (state as FilteredTodosLoaded)
              .filteredTodos
              .entries
              .map((e) => e.value)
              .expand((e) => e)
              .toList(),
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredTodosState> _mapDataUpdatedToState(
      FilteredTodoDataUpdated event) async* {
    // Had been handling due states here before, now going to handle that in DataBloc
    final updatedTodos =
        _filterTodos(event.todos, (state as FilteredTodosLoaded).activeFilter);
    yield FilteredTodosLoaded(
        updatedTodos, (state as FilteredTodosLoaded).activeFilter);
  }

  @override
  Future<void> close() {
    dataBlocSubscription?.cancel();
    return super.close();
  }
}
