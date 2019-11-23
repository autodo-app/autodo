import 'dart:async';

import 'package:autodo/blocs/cars.dart';

class Filter {
  String carName;
  bool enabled;

  Filter(this.carName, this.enabled);
}

class FilteringBLoC {
  Map<String, bool> filters = {};

  /// Must be called after the CarsBLoC is initialized
  Future<void> initialize() async {
    var cars = await CarsBLoC().getCars();
    if (cars != null) {
      cars.forEach((car) {
        if (!filters.containsKey(car.name)) {
          filters[car.name] = true; // default to showing all content
        }
      });
    }
  } 

  Map<String, bool> getFilters() {
    return filters;
  }

  List<Filter> getFiltersAsList() {
    List<Filter> out = [];
    filters.forEach((name, enabled) {
      out.add(Filter(name, enabled));
    });
    return out;
  }

  void setFilter(Filter filter) {
    filters[filter.carName] = filter.enabled;
  }

  bool containsKey(String carName) {
    return filters.containsKey(carName);
  }

  bool value(String carName) {
    return filters[carName];
  }

  Stream filteredDocuments() {
    StreamController.broadcast(

    );
  } 

  // Make the object a Singleton
  static final FilteringBLoC _bloc = FilteringBLoC._internal();
  factory FilteringBLoC() {
    return _bloc;
  }
  FilteringBLoC._internal();
}