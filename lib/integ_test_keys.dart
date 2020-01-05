import 'package:flutter/material.dart';

class IntegrationTestKeys {
  static const welcomeScreen = ValueKey('__welcome_screen__');
  static const signupScreen = ValueKey('__signup_screen__');
  static const homeScreen = ValueKey('__home_screen__');
  static const fabKey = ValueKey('__fab__');
  static const mainFab = ValueKey('__main_fab__');
  static const fabKeys = [
    ValueKey('new_refueling_fab'),
    ValueKey('new_todo_fab'),
    ValueKey('new_repeat_fab')
  ];
  static const addEditTodo = ValueKey('__add_edit_todo__');
  static const newUserScreen = ValueKey('__new_user_screen__');
  static const mileageNameField = ValueKey('__mileage_name_field__');
  static const mileageMileageField = ValueKey('__mileage_mileage_field__');
  static const mileageNextButton = ValueKey('__mileage_next_button__');
  static const latestOilChangeField = ValueKey('__latest_oil_change_field__');
  static const latestTireRotationField =
      ValueKey('__latest_tire_rotation_field__');
  static const latestNextButton = ValueKey('__latest_next_button__');
  static const setOilInterval = ValueKey('__set_oil_interval__');
  static const setTireRotationInterval =
      ValueKey('__set_tire_rotation_interval__');
  static const setRepeatsNext = ValueKey('__set_repeats_next__');
  static const todoCarForm = ValueKey('__todo_car_form__');
  static const todosScreenScroller = ValueKey('__todos_screen_scroller__');
}
