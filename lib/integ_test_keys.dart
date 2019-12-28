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
}
