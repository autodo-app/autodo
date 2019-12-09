import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AutodoLocalizations {
  static AutodoLocalizations of(BuildContext context) {
    return Localizations.of<AutodoLocalizations>(
      context,
      AutodoLocalizations,
    );
  }

  static String get appTitle => "auToDo";
  // TODO: change this for non-US locales
  static dateFormat(date) => (DateFormat("MM/dd/yyyy").format(date));
  static String get undo => "Undo";
  static todoDeleted(name) => "ToDo $name deleted.";
  static String get refuelingDeleted => "Refueling deleted.";
  static String get firstTimeDoingTask => "First Time Doing This Task.";
  static String get dueAt => "Due At";
  static String get distanceUnits => "miles";
  static String get distanceUnitsShort => "(mi)";
  static String get dueOn => "Due on";
  static String get pastDue => "Past Due";
  static String get dueSoon => "Due Soon";
  static String get upcoming => "Upcoming";
  static String get totalCost => "Total Cost";
  static String get moneyUnits => "\$";
  static String get moneyUnitsSuffix => "(USD)";
  static String get totalAmount => "Total Amount";
  static String get fuelUnits => "gal";
  static String get onLiteral => "on";
  static String get refueling => "Refueling";
  static String get at => "at";
  static String get requiredLiteral => "Required";
  static String get optional => "Optional";
  static String get odomReading => "Odometer Reading";
  static String get totalPrice => "Total Price";
  static String get refuelingDate => "Refueling Date";
  static String get refuelingAmount => "Refueling Amount";
  static String get chooseDate => "Choose Date";
  static String get invalidDate => "Not a valid date";
  static String get addRefueling => "Add Refueling";
  static String get editRefueling => "Edit Refueling";
  static String get saveChanges => "Save Changes";
  static String get carName => "Car Name";
  static String get mileage => "Mileage";
  static String get todoDueSoon => "Maintenance ToDo Due Soon";
}

class AutodoLocalizationsDelegate
    extends LocalizationsDelegate<AutodoLocalizations> {
  @override
  Future<AutodoLocalizations> load(Locale locale) =>
      Future(() => AutodoLocalizations());

  @override
  bool shouldReload(AutodoLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains("en");
}