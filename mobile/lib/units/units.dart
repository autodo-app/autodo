// The International System of Unit for length is the meter
// All units are expressed from this constants

import 'distance.dart';

export 'currency.dart';
export 'distance.dart';
export 'efficiency.dart';
export 'volume.dart';

enum FuelType { gasoline, diesel }

class Limits {
  static const minTodoMileage = 100 * Distance.kilometer;
  static const maxTodoMileage = 500000 * Distance.kilometer;
}
