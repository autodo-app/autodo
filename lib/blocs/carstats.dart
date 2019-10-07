class CarStatsBLoC {
  int currentCarMileage = 0;

  void setCurrentMileage(int update){
    currentCarMileage = update;
  }

  int getCurrentMileage() {
    return currentCarMileage;
  }
  static final CarStatsBLoC _self = CarStatsBLoC._internal();
  factory CarStatsBLoC() {
    return _self;
  }
  CarStatsBLoC._internal();
}