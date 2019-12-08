import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/blocs/refuelings/barrel.dart';
import 'package:autodo/models/barrel.dart';

class FilteredRefuelingsBloc extends Bloc<FilteredRefuelingsEvent, FilteredRefuelingsState> {
  final RefuelingsBloc refuelingsBloc;
  StreamSubscription refuelingsSubscription;

  FilteredRefuelingsBloc({@required this.refuelingsBloc}) {
    refuelingsSubscription = refuelingsBloc.listen((state) {
      if (state is RefuelingsLoaded) {
        add(UpdateRefuelings((refuelingsBloc.state as RefuelingsLoaded).refuelings));
      }
    });
  }

  @override
  FilteredRefuelingsState get initialState {
    return refuelingsBloc.state is RefuelingsLoaded
        ? FilteredRefuelingsLoaded(
            (refuelingsBloc.state as RefuelingsLoaded).refuelings,
            VisibilityFilter.all,
          )
        : FilteredRefuelingsLoading();
  }

  @override
  Stream<FilteredRefuelingsState> mapEventToState(FilteredRefuelingsEvent event) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateRefuelings) {
      yield* _mapRefuelingsUpdatedToState(event);
    }
  }

  Stream<FilteredRefuelingsState> _mapUpdateFilterToState(
    UpdateFilter event,
  ) async* {
    if (refuelingsBloc.state is RefuelingsLoaded) {
      yield FilteredRefuelingsLoaded(
        _mapRefuelingsToFilteredRefuelings(
          (refuelingsBloc.state as RefuelingsLoaded).refuelings,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredRefuelingsState> _mapRefuelingsUpdatedToState(
    UpdateRefuelings event,
  ) async* {
    final visibilityFilter = state is FilteredRefuelingsLoaded
        ? (state as FilteredRefuelingsLoaded).activeFilter
        : VisibilityFilter.all;
    yield FilteredRefuelingsLoaded(
      _mapRefuelingsToFilteredRefuelings(
        (refuelingsBloc.state as RefuelingsLoaded).refuelings,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  List<Refueling> _mapRefuelingsToFilteredRefuelings(
      List<Refueling> refuelings, VisibilityFilter filter) {
    return refuelings.where((refueling) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        // return !todo.complete;
        return true;
      } else {
        // return todo.complete;
        return true;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    refuelingsSubscription.cancel();
    return super.close();
  }
}