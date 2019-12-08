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
  static String get dueOn => "Due on";
  static String get pastDue => "Past Due";
  static String get dueSoon => "Due Soon";
  static String get upcoming => "Upcoming";
  static String get totalCost => "Total Cost";
  static String get moneyUnits => "\$";
  static String get totalAmount => "Total Amount";
  static String get fuelUnits => "gal";
  static String get onLiteral => "on";
  static String get refueling => "Refueling";
  static String get at => "at";
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