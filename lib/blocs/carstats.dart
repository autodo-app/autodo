class CarStatsBLoC {
  int currentCarMileage = 0;
  Map<String, int> lastCompletedRepeatTodos;

  void setCurrentMileage(int update){
    currentCarMileage = update;
  }

  int getCurrentMileage() {
    return currentCarMileage;
  }

  void setLastCompleted(String key, int val) {
    lastCompletedRepeatTodos[key] = val;
  }

  static final CarStatsBLoC _self = CarStatsBLoC._internal();
  factory CarStatsBLoC() {
    return _self;
  }
  CarStatsBLoC._internal();
}