import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../units/units.dart';

final List<Todo> defaultsImperial = [
  Todo(
      name: IntlKeys.oil,
      mileageRepeatInterval: 3500 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.tireRotation,
      mileageRepeatInterval: 7500 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.engineFilter,
      mileageRepeatInterval: 45000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.wiperBlades,
      mileageRepeatInterval: 30000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.alignmentCheck,
      mileageRepeatInterval: 40000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.cabinFilter,
      mileageRepeatInterval: 45000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.tires,
      mileageRepeatInterval: 50000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.brakes,
      mileageRepeatInterval: 60000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.sparkPlugs,
      mileageRepeatInterval: 60000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.frontStruts,
      mileageRepeatInterval: 75000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.rearStruts,
      mileageRepeatInterval: 75000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.battery,
      mileageRepeatInterval: 75000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.serpentineBelt,
      mileageRepeatInterval: 150000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.transmissionFluid,
      mileageRepeatInterval: 100000 * Distance.miles,
      completed: false),
  Todo(
      name: IntlKeys.coolantChange,
      mileageRepeatInterval: 100000 * Distance.miles,
      completed: false)
];

final List<Todo> defaultsMetric = [
  Todo(
      name: 'oil',
      mileageRepeatInterval: 6000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'tireRotation',
      mileageRepeatInterval: 12000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'engineFilter',
      mileageRepeatInterval: 75000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'wiperBlades',
      mileageRepeatInterval: 50000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'alignmentCheck',
      mileageRepeatInterval: 65000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'cabinFilter',
      mileageRepeatInterval: 75000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'tires',
      mileageRepeatInterval: 80000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'brakes',
      mileageRepeatInterval: 100000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'sparkPlugs',
      mileageRepeatInterval: 100000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'frontStruts',
      mileageRepeatInterval: 120000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'rearStruts',
      mileageRepeatInterval: 120000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'battery',
      mileageRepeatInterval: 120000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'serpentineBelt',
      mileageRepeatInterval: 250000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'transmissionFluid',
      mileageRepeatInterval: 150000 * Distance.kilometer,
      completed: false),
  Todo(
      name: 'coolantChange',
      mileageRepeatInterval: 150000 * Distance.kilometer,
      completed: false)
];
